#!/bin/sh

set -ex

# Wait for the database container
# See: https://docs.docker.com/compose/startup-order/
export PGHOST=${DB_HOST:-db}
export PGPORT=${DB_PORT:-5432}

fixtures_dir=${FIXTURES_DIR:-/app/fixtures}

uwsgi_port=${UWSGI_PORT:-8000}
uwsgi_processes=${UWSGI_PROCESSES:-2}
uwsgi_threads=${UWSGI_THREADS:-2}

mountpoint=${SUBPATH:-/}

# wait for required services
${SCRIPTPATH}/wait_for_db.sh

# Apply database migrations
echo >&2 "Apply database migrations"
python src/manage.py migrate

# START CUSTOM
if [ -n "$IMPORT_JSON" ]; then
    if ls /app/init/$IMPORT_JSON >/dev/null 2>&1; then
        cp -rf /app/init/$IMPORT_JSON $fixtures_dir
    else
        touch $fixtures_dir/setup.json
        echo $IMPORT_JSON >>$fixtures_dir/setup.json
        sed '/^$/d' $fixtures_dir/setup.json
    fi
fi

/create-superuser.sh admin admin@admin.org admin
# END CUSTOM

# Load any JSON fixtures present
if [ -d $fixtures_dir ]; then
    echo "Loading fixtures from $fixtures_dir"

    for fixture in $(ls "$fixtures_dir/"*.json); do
        echo "Loading fixture $fixture"
        python src/manage.py loaddata $fixture
    done
fi

# Create superuser
# specify password by setting DJANGO_SUPERUSER_PASSWORD in the env
# specify username by setting OPENZAAK_SUPERUSER_USERNAME in the env
# specify email by setting OPENZAAK_SUPERUSER_EMAIL in the env
if [ -n "${OPENZAAK_SUPERUSER_USERNAME}" ]; then
    python src/manage.py createinitialsuperuser \
        --no-input \
        --username "${OPENZAAK_SUPERUSER_USERNAME}" \
        --email "${OPENZAAK_SUPERUSER_EMAIL:-admin\@admin.org}"
    unset OPENZAAK_SUPERUSER_USERNAME OPENZAAK_SUPERUSER_EMAIL DJANGO_SUPERUSER_PASSWORD
fi

# Start server
echo >&2 "Starting server"
exec uwsgi \
    --http :$uwsgi_port \
    --http-keepalive \
    --manage-script-name \
    --mount $mountpoint=openzaak.wsgi:application \
    --static-map /static=/app/static \
    --static-map /media=/app/media \
    --chdir src \
    --enable-threads \
    --processes $uwsgi_processes \
    --threads $uwsgi_threads \
    --buffer-size=65535
