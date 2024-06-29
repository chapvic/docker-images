
# -----------------------
# Export global variables
# -----------------------
export TZ=${TZ:-'Europe/Moscow'}
export LC=${LC:-'ru_RU.UTF-8'}
export PGDATA=${PGDATA:-/data}
export POSTGRES_CONFIG=${POSTGRES_CONFIG:-}
export POSTGRES_OPTIONS=${POSTGRES_OPTIONS:-}
export SHAREDIR="/opt/pgpro/std-${PGPRO_VERSION}/share"

# -------------------------
# Reconfigure postgres.conf
# -------------------------
function _fix_pg_config() {
    if [[ ! -f "$PGDATA/postgresql.conf" ]] && [[ -f "$SHAREDIR/postgresql.conf.sample" ]]; then
        cp -f $SHAREDIR/postgresql.conf.sample $PGDATA/postgresql.conf
    fi
    # Update configuration
    sed -i -r \
        -e "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" \
        -e "s!^#?(log_timezone)\s*=\s*\S+.*!\1 = '"$TZ"'!" \
        -e "s!^#?(timezone)\s*=\s*\S+.*!\1 = '"$TZ"'!" \
        -e "s!^#?(lc_messages)\s*=\s*\S+.*!\1 = '"$LC"'!" \
        -e "s!^#?(lc_monetary)\s*=\s*\S+.*!\1 = '"$LC"'!" \
        -e "s!^#?(lc_numeric)\s*=\s*\S+.*!\1 = '"$LC"'!" \
        -e "s!^#?(lc_time)\s*=\s*\S+.*!\1 = '"$LC"'!" \
        $PGDATA/postgresql.conf
    # Check for $POSTGRES_CONFIG values
    IFS=$'\n'
    for conf in $POSTGRES_CONFIG; do
        var=$(echo $conf | awk -F'=' '{print $1}' | xargs)
        val=$(echo $conf | awk -F'=' '{print $2}')
        sed -i -r -e "s!^#?("$var")\s*=\s*\S+.*!\1 = "${val##* }"!" $PGDATA/postgresql.conf
    done
    IFS=' '
}
