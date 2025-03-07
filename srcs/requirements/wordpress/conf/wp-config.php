<?php
/**
 * WordPress の基本設定
 *
 * このファイルは、インストール時に wp-config.php 作成ツールが利用します。
 * ウェブサイトを作成する必要がありません。このファイルを "wp-config.php" という名前でコピーして
 * 直接値を入力してもかまいません。
 *
 * このファイルには、以下の設定が含まれています：
 *
 * * データベース設定
 * * 秘密鍵
 * * データベーステーブルの接頭辞
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** データベース設定 - こちらの情報はホスティング先から入手してください ** //
/** WordPress のためのデータベース名 */

define( 'DB_NAME', getenv('DB_NAME') );
define( 'DB_USER', getenv('DB_USER') );
define( 'DB_PASSWORD', getenv('DB_PASSWORD') );
define( 'DB_HOST', getenv('DB_HOST') );
define( 'WP_HOME', getenv('WP_FULL_URL') );
define( 'WP_SITEURL', getenv('WP_FULL_URL') );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

/**#@+
 * 認証用ユニークキーと salt
 *
 * これらを異なるユニークフレーズに変更してください！
 * {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org の秘密鍵サービス} で自動生成することもできます。
 *
 * これらをいつでも変更して、既存のすべての cookie を無効にすることができます。
 * これにより、すべてのユーザーは次回のログイン時に再度ログインする必要があります。
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '' );
define( 'SECURE_AUTH_KEY',  '' );
define( 'LOGGED_IN_KEY',    '' );
define( 'NONCE_KEY',        '' );
define( 'AUTH_SALT',        '' );
define( 'SECURE_AUTH_SALT', '' );
define( 'LOGGED_IN_SALT',   '' );
define( 'NONCE_SALT',       '' );

/**#@-*/

/**
 * WordPress データベーステーブルの接頭辞
 *
 * それぞれにユニークな接頭辞を与えることで一つのデータベースに複数の WordPress を
 * インストールすることができます。半角英数字と下線のみを使用してください！
 */
$table_prefix = 'wp_';

/**
 * 開発者へ: WordPress デバッグモード
 *
 * この値を true にすると、開発中に注意 (notice) を表示します。
 * テーマおよびプラグインの開発者には、その開発環境においてこの WP_DEBUG を
 * 使用することを強く推奨します。
 *
 * その他のデバッグに利用できる定数については
 * ドキュメンテーションをご覧ください。
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', true );

/* この行と「編集が必要なのはここまでです」の行の間にカスタム値を追加してください。 */



/* 編集が必要なのはここまでです！使いやすいブログライフをお楽しみください。 */

/** WordPress ディレクトリの絶対パス */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** WordPress ファイルの場所と変数をセットアップ */
require_once ABSPATH . 'wp-settings.php';