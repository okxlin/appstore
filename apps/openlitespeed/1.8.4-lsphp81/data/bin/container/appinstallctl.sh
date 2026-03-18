#!/bin/bash
DEFAULT_VH_ROOT='/var/www/vhosts'
VH_DOC_ROOT=''
VHNAME=''
APP_NAME=''
DOMAIN=''
WWW_UID=''
WWW_GID=''
WP_CONST_CONF=''
PUB_IP=$(curl -s http://checkip.amazonaws.com)
DB_HOST='mysql'
PLUGINLIST="litespeed-cache.zip"
THEME='twentytwenty'
EPACE='        '

echow(){
    FLAG=${1}
    shift
    echo -e "\033[1m${EPACE}${FLAG}\033[0m${@}"
}

help_message(){
	echo -e "\033[1mOPTIONS\033[0m"
    echow '-A, -app [wordpress] -D, --domain [DOMAIN_NAME]'
    echo "${EPACE}${EPACE}Example: appinstallctl.sh --app wordpress --domain example.com"
    echow '-H, --help'
    echo "${EPACE}${EPACE}Display help and exit."
    exit 0
}

check_input(){
    if [ -z "${1}" ]; then
        help_message
        exit 1
    fi
}

linechange(){
    LINENUM=$(grep -n "${1}" ${2} | cut -d: -f 1)
    if [ -n "${LINENUM}" ] && [ "${LINENUM}" -eq "${LINENUM}" ] 2>/dev/null; then
        sed -i "${LINENUM}d" ${2}
        sed -i "${LINENUM}i${3}" ${2}
    fi 
}

ck_ed(){
    if [ ! -f /bin/ed ]; then
        echo "Install ed package.."
        apt-get install ed -y > /dev/null 2>&1
    fi    
}

ck_unzip(){
    if [ ! -f /usr/bin/unzip ]; then 
        echo "Install unzip package.."
        apt-get install unzip -y > /dev/null 2>&1
    fi		
}

get_owner(){
	WWW_UID=$(stat -c "%u" ${DEFAULT_VH_ROOT})
	WWW_GID=$(stat -c "%g" ${DEFAULT_VH_ROOT})
	if [ ${WWW_UID} -eq 0 ] || [ ${WWW_GID} -eq 0 ]; then
		WWW_UID=1000
		WWW_GID=1000
		echo "Set owner to ${WWW_UID}"
	fi
}

get_db_pass(){
	if [ -f ${DEFAULT_VH_ROOT}/${1}/.db_pass ]; then
		SQL_DB=$(grep -i Database ${VH_ROOT}/.db_pass | awk -F ':' '{print $2}' | tr -d '"')
		SQL_USER=$(grep -i Username ${VH_ROOT}/.db_pass | awk -F ':' '{print $2}' | tr -d '"')
		SQL_PASS=$(grep -i Password ${VH_ROOT}/.db_pass | awk -F ':' '{print $2}' | tr -d '"')
	else
		echo 'db pass file can not locate, skip wp-config pre-config.'
	fi
}

set_vh_docroot(){
	if [ "${VHNAME}" != '' ]; then
	    VH_ROOT="${DEFAULT_VH_ROOT}/${VHNAME}"
	    VH_DOC_ROOT="${DEFAULT_VH_ROOT}/${VHNAME}/html"
		WP_CONST_CONF="${VH_DOC_ROOT}/wp-content/plugins/litespeed-cache/data/const.default.ini"
	elif [ -d ${DEFAULT_VH_ROOT}/${1}/html ]; then
	    VH_ROOT="${DEFAULT_VH_ROOT}/${1}"
        VH_DOC_ROOT="${DEFAULT_VH_ROOT}/${1}/html"
		WP_CONST_CONF="${VH_DOC_ROOT}/wp-content/plugins/litespeed-cache/data/const.default.ini"
	else
	    echo "${DEFAULT_VH_ROOT}/${1}/html does not exist, please add domain first! Abort!"
		exit 1
	fi	
}

check_sql_native(){
	local COUNTER=0
	local LIMIT_NUM=100
	until [ "$(curl -v mysql:3306 2>&1 | grep -i 'native\|Connected')" ]; do
		echo "Counter: ${COUNTER}/${LIMIT_NUM}"
		COUNTER=$((COUNTER+1))
		if [ ${COUNTER} = 10 ]; then
			echo '--- MySQL is starting, please wait... ---'
		elif [ ${COUNTER} = ${LIMIT_NUM} ]; then	
			echo '--- MySQL is timeout, exit! ---'
			exit 1
		fi
		sleep 1
	done
}

install_wp_plugin(){
    for PLUGIN in ${PLUGINLIST}; do
        wget -q -P ${VH_DOC_ROOT}/wp-content/plugins/ https://downloads.wordpress.org/plugin/${PLUGIN}
        if [ ${?} = 0 ]; then
		    ck_unzip
            unzip -qq -o ${VH_DOC_ROOT}/wp-content/plugins/${PLUGIN} -d ${VH_DOC_ROOT}/wp-content/plugins/
        else
            echo "${PLUGINLIST} FAILED to download"
        fi
    done
    rm -f ${VH_DOC_ROOT}/wp-content/plugins/*.zip
}

set_htaccess(){
    if [ ! -f ${VH_DOC_ROOT}/.htaccess ]; then 
        touch ${VH_DOC_ROOT}/.htaccess
    fi   
    cat << EOM > ${VH_DOC_ROOT}/.htaccess
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOM
}

get_theme_name(){
    THEME_NAME=$(grep WP_DEFAULT_THEME ${VH_DOC_ROOT}/wp-includes/default-constants.php | grep -v '!' | awk -F "'" '{print $4}')
    echo "${THEME_NAME}" | grep 'twenty' >/dev/null 2>&1
    if [ ${?} = 0 ]; then
        THEME="${THEME_NAME}"
    fi
}

set_lscache(){ 
    cat << EOM > "${WP_CONST_CONF}" 
;
; This is the predefined default LSCWP configuration file
;
; All the keys and values please refer \`src/const.cls.php\`
;
; Comments start with \`;\`
;
;; -------------------------------------------------- ;;
;; --------------          General              ----------------- ;;
;; -------------------------------------------------- ;;
; O_AUTO_UPGRADE
auto_upgrade = false
; O_API_KEY
api_key = ''
; O_SERVER_IP
server_ip = ''
; O_NEWS
news = false
;; -------------------------------------------------- ;;
;; --------------               Cache           ----------------- ;;
;; -------------------------------------------------- ;;
cache-priv = true
cache-commenter = true
cache-rest = true
cache-page_login = true
cache-favicon = true
cache-resources = true
cache-browser = false
cache-mobile = false
cache-mobile_rules = 'Mobile
Android
Silk/
Kindle
BlackBerry
Opera Mini
Opera Mobi'
cache-exc_useragents = ''
cache-exc_cookies = ''
cache-exc_qs = ''
cache-exc_cat = ''
cache-exc_tag = ''
cache-force_uri = ''
cache-force_pub_uri = ''
cache-priv_uri = ''
cache-exc = ''
cache-exc_roles = ''
cache-drop_qs = 'fbclid
gclid
utm*
_ga'
cache-ttl_pub = 604800
cache-ttl_priv = 1800
cache-ttl_frontpage = 604800
cache-ttl_feed = 604800
; O_CACHE_TTL_REST
cache-ttl_rest = 604800
cache-ttl_browser = 31557600
cache-login_cookie = ''
cache-vary_group = ''
cache-ttl_status = '403 3600
404 3600
500 3600'
;; -------------------------------------------------- ;;
;; --------------               Purge           ----------------- ;;
;; -------------------------------------------------- ;;
; O_PURGE_ON_UPGRADE
purge-upgrade = true
; O_PURGE_STALE
purge-stale = true
purge-post_all  = false
purge-post_f    = true
purge-post_h    = true
purge-post_p    = true
purge-post_pwrp = true
purge-post_a    = true
purge-post_y    = false
purge-post_m    = true
purge-post_d    = false
purge-post_t    = true
purge-post_pt   = true
purge-timed_urls = ''
purge-timed_urls_time = ''
purge-hook_all = 'switch_theme
wp_create_nav_menu
wp_update_nav_menu
wp_delete_nav_menu
create_term
edit_terms
delete_term
add_link
edit_link
delete_link'
;; -------------------------------------------------- ;;
;; --------------        ESI        ----------------- ;;
;; -------------------------------------------------- ;;
; O_ESI
esi = false
; O_ESI_CACHE_ADMBAR
esi-cache_admbar = true
; O_ESI_CACHE_COMMFORM
esi-cache_commform = true
; O_ESI_NONCE
esi-nonce = 'stats_nonce
subscribe_nonce'
;; -------------------------------------------------- ;;
;; --------------     Utilities     ----------------- ;;
;; -------------------------------------------------- ;;
util-heartbeat = true
util-instant_click = false
util-check_advcache = true
util-no_https_vary = false
;; -------------------------------------------------- ;;
;; --------------               Debug           ----------------- ;;
;; -------------------------------------------------- ;;
; O_DEBUG_DISABLE_ALL
debug-disable_all = false
; O_DEBUG
debug = false
; O_DEBUG_IPS
debug-ips = '127.0.0.1'
; O_DEBUG_LEVEL
debug-level = false
; O_DEBUG_FILESIZE
debug-filesize = 3
; O_DEBUG_COOKIE
debug-cookie = false
; O_DEBUG_COLLAPS_QS
debug-collaps_qs = false
; O_DEBUG_INC
debug-inc = ''
; O_DEBUG_EXC
debug-exc = ''
;; -------------------------------------------------- ;;
;; --------------           DB Optm     ----------------- ;;
;; -------------------------------------------------- ;;
; O_DB_OPTM_REVISIONS_MAX
db_optm-revisions_max = 0
; O_DB_OPTM_REVISIONS_AGE
db_optm-revisions_age = 0
;; -------------------------------------------------- ;;
;; --------------         HTML Optm     ----------------- ;;
;; -------------------------------------------------- ;;
; O_OPTM_CSS_MIN
optm-css_min = false
optm-css_inline_min = false
; O_OPTM_CSS_COMB
optm-css_comb = false
optm-css_comb_priority = false
; O_OPTM_CSS_HTTP2
optm-css_http2 = false
optm-css_exc = ''
; O_OPTM_JS_MIN
optm-js_min = false
optm-js_inline_min = false
; O_OPTM_JS_COMB
optm-js_comb = false
optm-js_comb_priority = false
; O_OPTM_JS_HTTP2
optm-js_http2 = false
; O_OPTM_EXC_JQ
optm-js_exc = ''
optm-ttl = 604800
optm-html_min = false
optm-qs_rm = false
optm-ggfonts_rm = false
; O_OPTM_CSS_ASYNC
optm-css_async = false
; O_OPTM_CCSS_GEN
optm-ccss_gen = true
; O_OPTM_CCSS_ASYNC
optm-ccss_async = true
; O_OPTM_CSS_ASYNC_INLINE
optm-css_async_inline = true
; O_OPTM_CSS_FONT_DISPLAY
optm-css_font_display = false
; O_OPTM_JS_DEFER
optm-js_defer = false
; O_OPTM_JS_INLINE_DEFER
optm-js_inline_defer = false
optm-emoji_rm = false
optm-exc_jq = true
optm-ggfonts_async = false
optm-max_size = 2
optm-rm_comment = false
optm-exc_roles = ''
optm-ccss_con = ''
optm-js_defer_exc = ''
; O_OPTM_DNS_PREFETCH
optm-dns_prefetch = ''
; O_OPTM_DNS_PREFETCH_CTRL
optm-dns_prefetch_ctrl = false
optm-exc = ''
; O_OPTM_CCSS_SEP_POSTTYPE
optm-ccss_sep_posttype = ''
; O_OPTM_CCSS_SEP_URI
optm-ccss_sep_uri = ''
;; -------------------------------------------------- ;;
;; --------------       Object Cache    ----------------- ;;
;; -------------------------------------------------- ;;
object = true
object-kind = false
;object-host = 'localhost'
object-host = '/var/www/memcached.sock'
;object-port = 11211
cache_object_port = ''
object-life = 360
object-persistent = true
object-admin = true
object-transients = true
object-db_id = 0
object-user = ''
object-pswd = ''
object-global_groups = 'users
userlogins
usermeta
user_meta
site-transient
site-options
site-lookup
blog-lookup
blog-details
rss
global-posts
blog-id-cache'
object-non_persistent_groups = 'comment
counts
plugins
wc_session_id'
;; -------------------------------------------------- ;;
;; --------------        Discussion     ----------------- ;;
;; -------------------------------------------------- ;;
; O_DISCUSS_AVATAR_CACHE
discuss-avatar_cache = false
; O_DISCUSS_AVATAR_CRON
discuss-avatar_cron = false
; O_DISCUSS_AVATAR_CACHE_TTL
discuss-avatar_cache_ttl = 604800
;; -------------------------------------------------- ;;
;; --------------                Media          ----------------- ;;
;; -------------------------------------------------- ;;
; O_MEDIA_LAZY
media-lazy = false
; O_MEDIA_LAZY_PLACEHOLDER
media-lazy_placeholder = ''
; O_MEDIA_PLACEHOLDER_RESP
media-placeholder_resp = false
; O_MEDIA_PLACEHOLDER_RESP_COLOR
media-placeholder_resp_color = '#cfd4db'
; O_MEDIA_PLACEHOLDER_RESP_GENERATOR
media-placeholder_resp_generator = false
; O_MEDIA_PLACEHOLDER_RESP_SVG
media-placeholder_resp_svg = '<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}"><rect width="100%" height="100%" fill="{color}"/></svg>'
; O_MEDIA_PLACEHOLDER_LQIP
media-placeholder_lqip = false
; O_MEDIA_PLACEHOLDER_LQIP_QUAL
media-placeholder_lqip_qual = 4
; O_MEDIA_PLACEHOLDER_RESP_ASYNC
media-placeholder_resp_async = true
; O_MEDIA_IFRAME_LAZY
media-iframe_lazy = false
; O_MEDIA_LAZYJS_INLINE
media-lazyjs_inline = false
; O_MEDIA_LAZY_EXC
media-lazy_exc = ''
; O_MEDIA_LAZY_CLS_EXC
media-lazy_cls_exc = ''
; O_MEDIA_LAZY_PARENT_CLS_EXC
media-lazy_parent_cls_exc = ''
; O_MEDIA_IFRAME_LAZY_CLS_EXC
media-iframe_lazy_cls_exc = ''
; O_MEDIA_IFRAME_LAZY_PARENT_CLS_EXC
media-iframe_lazy_parent_cls_exc = ''
; O_MEDIA_LAZY_URI_EXC
media-lazy_uri_exc = ''
;; -------------------------------------------------- ;;
;; --------------         Image Optm    ----------------- ;;
;; -------------------------------------------------- ;;
img_optm-auto = false
img_optm-cron = true
img_optm-ori = true
img_optm-rm_bkup = false
img_optm-webp = false
img_optm-lossless = false
img_optm-exif = false
img_optm-webp_replace = false
img_optm-webp_attr = 'img.src
div.data-thumb
img.data-src
div.data-large_image
img.retina_logo_url
div.data-parallax-image
video.poster'
img_optm-webp_replace_srcset = false
img_optm-jpg_quality = 82
;; -------------------------------------------------- ;;
;; --------------               Crawler         ----------------- ;;
;; -------------------------------------------------- ;;
crawler = false
crawler-inc_posts = true
crawler-inc_pages = true
crawler-inc_cats = true
crawler-inc_tags = true
crawler-exc_cpt = ''
crawler-order_links = 'date_desc'
crawler-usleep = 500
crawler-run_duration = 400
crawler-run_interval = 600
crawler-crawl_interval = 302400
crawler-threads = 3
crawler-timeout = 30
crawler-load_limit = 1
; O_CRAWLER_SITEMAP
crawler-sitemap = ''
; O_CRAWLER_DROP_DOMAIN
crawler-drop_domain = true
crawler-roles = ''
crawler-cookies = ''
;; -------------------------------------------------- ;;
;; --------------                Misc           ----------------- ;;
;; -------------------------------------------------- ;;
; O_MISC_HTACCESS_FRONT
misc-htaccess_front = ''
; O_MISC_HTACCESS_BACK
misc-htaccess_back = ''
; O_MISC_HEARTBEAT_FRONT
misc-heartbeat_front = false
; O_MISC_HEARTBEAT_FRONT_TTL
misc-heartbeat_front_ttl = 60
; O_MISC_HEARTBEAT_BACK
misc-heartbeat_back = false
; O_MISC_HEARTBEAT_BACK_TTL
misc-heartbeat_back_ttl = 60
; O_MISC_HEARTBEAT_EDITOR
misc-heartbeat_editor = false
; O_MISC_HEARTBEAT_EDITOR_TTL
misc-heartbeat_editor_ttl = 15
;; -------------------------------------------------- ;;
;; --------------                CDN            ----------------- ;;
;; -------------------------------------------------- ;;
cdn = false
cdn-ori = ''
cdn-ori_dir = ''
cdn-exc = ''
cdn-remote_jq = false
cdn-quic = false
cdn-quic_email = ''
cdn-quic_key = ''
cdn-cloudflare = false
cdn-cloudflare_email = ''
cdn-cloudflare_key = ''
cdn-cloudflare_name = ''
cdn-cloudflare_zone = ''
; \`cdn-mapping\` needs to be put in the end with a section tag
;; -------------------------------------------------- ;;
;; --------------                CDN 2          ----------------- ;;
;; -------------------------------------------------- ;;
; <------------ CDN Mapping Example BEGIN -------------------->
; Need to keep the section tag \`[cdn-mapping]\` before list.
;
; NOTE 1) Need to set all child options to make all resources to be replaced without missing.
; NOTE 2) \`url[n]\` option must have to enable the row setting of \`n\`.
; NOTE 3) This section needs to be put in the end of this .ini file
;
; To enable the 2nd mapping record by default, please remove the \`;;\` in the related lines.
[cdn-mapping]
url[0] = ''
inc_js[0] = true
inc_css[0] = true
inc_img[0] = true
filetype[0] = '.aac
.css
.eot
.gif
.jpeg
.js
.jpg
.less
.mp3
.mp4
.ogg
.otf
.pdf
.png
.svg
.ttf
.woff'
;;url[1] = 'https://2nd_CDN_url.com/'
;;filetype[1] = '.webm'
; <------------ CDN Mapping Example END ------------------>
EOM

    THEME_PATH="${VH_DOC_ROOT}/wp-content/themes/${THEME}"
    if [ ! -f ${THEME_PATH}/functions.php ]; then
        cat >> "${THEME_PATH}/functions.php" <<END
<?php
require_once( WP_CONTENT_DIR.'/../wp-admin/includes/plugin.php' );
\$path = 'litespeed-cache/litespeed-cache.php' ;
if (!is_plugin_active( \$path )) {
    activate_plugin( \$path ) ;
    rename( __FILE__ . '.bk', __FILE__ );
}
END
    elif [ ! -f ${THEME_PATH}/functions.php.bk ]; then 
        cp ${THEME_PATH}/functions.php ${THEME_PATH}/functions.php.bk
        ck_ed
        ed ${THEME_PATH}/functions.php << END >>/dev/null 2>&1
2i
require_once( WP_CONTENT_DIR.'/../wp-admin/includes/plugin.php' );
\$path = 'litespeed-cache/litespeed-cache.php' ;
if (!is_plugin_active( \$path )) {
    activate_plugin( \$path ) ;
    rename( __FILE__ . '.bk', __FILE__ );
}
.
w
q
END
    fi
}

preinstall_wordpress(){
	if [ "${VHNAME}" != '' ]; then
	    get_db_pass ${VHNAME}
	else
		get_db_pass ${DOMAIN}
	fi	
	if [ ! -f ${VH_DOC_ROOT}/wp-config.php ] && [ -f ${VH_DOC_ROOT}/wp-config-sample.php ]; then
		cp ${VH_DOC_ROOT}/wp-config-sample.php ${VH_DOC_ROOT}/wp-config.php
		NEWDBPWD="define('DB_PASSWORD', '${SQL_PASS}');"
		linechange 'DB_PASSWORD' ${VH_DOC_ROOT}/wp-config.php "${NEWDBPWD}"
		NEWDBPWD="define('DB_USER', '${SQL_USER}');"
		linechange 'DB_USER' ${VH_DOC_ROOT}/wp-config.php "${NEWDBPWD}"
		NEWDBPWD="define('DB_NAME', '${SQL_DB}');"
		linechange 'DB_NAME' ${VH_DOC_ROOT}/wp-config.php "${NEWDBPWD}"
        #NEWDBPWD="define('DB_HOST', '${PUB_IP}');"
		NEWDBPWD="define('DB_HOST', '${DB_HOST}');"
		linechange 'DB_HOST' ${VH_DOC_ROOT}/wp-config.php "${NEWDBPWD}"
	elif [ -f ${VH_DOC_ROOT}/wp-config.php ]; then
		echo "${VH_DOC_ROOT}/wp-config.php already exist, exit !"
		exit 1
	else
		echo 'Skip!'
		exit 2
	fi 
}

app_wordpress_dl(){
	if [ ! -f "${VH_DOC_ROOT}/wp-config.php" ] && [ ! -f "${VH_DOC_ROOT}/wp-config-sample.php" ]; then
		wp core download \
			--allow-root \
			--quiet
	else
	    echo 'wordpress already exist, abort!'
		exit 1
	fi
}

change_owner(){
		if [ "${VHNAME}" != '' ]; then
		    chown -R ${WWW_UID}:${WWW_GID} ${DEFAULT_VH_ROOT}/${VHNAME} 
		else
		    chown -R ${WWW_UID}:${WWW_GID} ${DEFAULT_VH_ROOT}/${DOMAIN}
		fi
}

main(){
	set_vh_docroot ${DOMAIN}
	get_owner
	cd ${VH_DOC_ROOT}
	if [ "${APP_NAME}" = 'wordpress' ] || [ "${APP_NAME}" = 'wp' ]; then
		check_sql_native
		app_wordpress_dl
		preinstall_wordpress
		install_wp_plugin
		set_htaccess
		get_theme_name
		set_lscache
		change_owner
		exit 0
	else
		echo "APP: ${APP_NAME} not support, exit!"
		exit 1	
	fi
}

check_input ${1}
while [ ! -z "${1}" ]; do
	case ${1} in
		-[hH] | -help | --help)
			help_message
			;;
		-[aA] | -app | --app) shift
			check_input "${1}"
			APP_NAME="${1}"
			;;
		-[dD] | -domain | --domain) shift
			check_input "${1}"
			DOMAIN="${1}"
			;;
		-vhname | --vhname) shift
			VHNAME="${1}"
			;;	       
		*) 
			help_message
			;;              
	esac
	shift
done
main
