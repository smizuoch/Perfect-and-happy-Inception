<?php
/**
 * The base configuration for WordPress
 */

// ** Database settings - You can get this info from your web host ** //
define( 'DB_NAME', getenv('WORDPRESS_DB_NAME') );
define( 'DB_USER', getenv('WORDPRESS_DB_USER') );
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') );
define( 'DB_HOST', getenv('WORDPRESS_DB_HOST') );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

// デバッグモードを有効化（troubleshooting中）
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );

/**
 * Authentication unique keys and salts.
 */
define('AUTH_KEY',         'unique phrase 1');
define('SECURE_AUTH_KEY',  'unique phrase 2');
define('LOGGED_IN_KEY',    'unique phrase 3');
define('NONCE_KEY',        'unique phrase 4');
define('AUTH_SALT',        'unique phrase 5');
define('SECURE_AUTH_SALT', 'unique phrase 6');
define('LOGGED_IN_SALT',   'unique phrase 7');
define('NONCE_SALT',       'unique phrase 8');

/**
 * WordPress database table prefix.
 */
$table_prefix = getenv('WORDPRESS_TABLE_PREFIX') ?: 'wp_';

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';