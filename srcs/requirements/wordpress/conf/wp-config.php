<?php
/**
 * The base configuration for WordPress
 */

// ** Database settings ** //
define( 'DB_NAME', getenv('WORDPRESS_DB_NAME') );
define( 'DB_USER', getenv('WORDPRESS_DB_USER') );
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') );
define( 'DB_HOST', getenv('WORDPRESS_DB_HOST') );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

/**
 * Authentication unique keys and salts.
 */
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');

/**
 * WordPress database table prefix.
 */
$table_prefix = getenv('WORDPRESS_TABLE_PREFIX') ?: 'wp_';

/**
 * For developers: WordPress debugging mode.
 */
define( 'WP_DEBUG', false );

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';