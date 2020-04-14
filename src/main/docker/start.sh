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

until pg_isready; do
  >&2 echo "Waiting for database connection..."
  sleep 1
done

>&2 echo "Database is up."

# Apply database migrations
>&2 echo "Apply database migrations"
python src/manage.py migrate

# Import JSON or else create default admin user.
if [ -z "$IMPORT_JSON" ]
then
	echo "Nothing to import"
	/create-superuser.sh admin admin@admin.org admin
else
	touch $fixtures_dir/setup.json
	echo $IMPORT_JSON >> $fixtures_dir/setup.json
fi

# Load any JSON fixtures present
if [ -d $fixtures_dir ]; then
    echo "Loading fixtures from $fixtures_dir"

    for fixture in $(ls "$fixtures_dir/"*.json)
    do
        echo "Loading fixture $fixture"
        python src/manage.py loaddata $fixture
    done
fi

#>&2 echo "Creating superuser"
#/create-superuser.sh admin admin@admin.org admin

# Start server
>&2 echo "Starting server"
uwsgi \
    --http :$uwsgi_port \
    --module openzaak.wsgi \
    --static-map ${SUBPATH}/static=/app/static \
    --static-map /static=/app/static \
    --static-map /media=/app/media  \
    --chdir src \
    --enable-threads \
    --processes $uwsgi_processes \
    --threads $uwsgi_threads \
    --buffer-size=65535