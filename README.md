# vagrant-docker-php #

Vagrant+Docker(Docker Compose)で作るPHPの実行環境

php,nginx,mysqlのコンテナを動かして、PHPを実行させる環境です。

## 必要なもの ##

* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](https://www.vagrantup.com)
* Vagrantプラグイン

	* [Vagrant Host Manager](https://github.com/smdahlen/vagrant-hostmanager)

	  ```
	  vagrant plugin install vagrant-hostmanager
	  ```

* [Docker](https://www.docker.com/) バージョン 1.5.0 以上
* [Docker Compose](http://docs.docker.com/compose/)


## セットアップ ##

ホストOSより

```bash
	git clone https://github.com/mistymagich/vagrant-docker-php.git
	cd vagrant-docker-php
	vagrant up
```

正常に起動できれば、ブラウザで http://sandbox.local でアクセスするとPHPInfoが表示されます。


## 構造 ##

### Nginxコンテナ ###

[公式Nginxコンテナ](https://registry.hub.docker.com/_/nginx/)をもとに、[Set up Automatic Virtual Hosts with Nginx and Apache](http://www.sitepoint.com/set-automatic-virtual-hosts-nginx-apache/)の設定を用いて、任意のホスト名「**hoge**.local」に対して、ドキュメントルートはホストOSにある「www/**hoge**/public」を参照するようにしています。

ゲストOSのポートTCP80,443にアクセスすることでNginxコンテナにアクセスできます。

### MySQLコンテナ ###

[公式MySQLコンテナ](https://registry.hub.docker.com/_/mysql/)をそのまま利用しています。

データの永続化はしていません。

ゲストOSのポートTCP3306にアクセスすることでMySQLコンテナにアクセスできます。

ユーザー名はroot、パスワードは**docker-compose.yml**にある環境変数**MYSQL_ROOT_PASSWORD**の値です。

### PHP(FPM)コンテナ ###

[公式PHPコンテナ](https://registry.hub.docker.com/_/php/)のFPMをもとに、以下のモジュールを追加しています。

* pdo
* pdo_mysql
* gd
* mysqli
* mcrypt
* mbstring
* iconv
* xdebug

ホスト名**mysql**でMySQLコンテナを参照します。


### 関係図 ###

![関係図](https://raw.githubusercontent.com/mistymagich/vagrant-docker-php/master/relation.png)

PHP(FPM)コンテナはホスト名mysqlでMySQLコンテナにアクセスできます。
Nginxコンテナはホスト名phpでPHP(FPM)コンテナを参照しています。

## PHPMyAdminのインストールサンプル ##

1. **Vagrantfile**の**config.hostmanager.aliases**に**phpmyadmin.local**を追加してvagrant up
2. wwwフォルダに**phpmyadmin**フォルダを作成し、さらにその中に**public**フォルダを作成する
3. [PHPMyAdmin](http://www.phpmyadmin.net/home_page/downloads.php)をダウンロード
4. 解凍して、中にあるPHPファイルを2.で作成したpublic以下にコピー
5. config.sample.incをconfig.incにリネーム
6. config.incを編集

   ホスト名を変更

   ```diff
     /* Authentication type */
     $cfg['Servers'][$i]['auth_type'] = 'cookie';
     /* Server parameters */
    -$cfg['Servers'][$i]['host'] = 'localhost';
    +$cfg['Servers'][$i]['host'] = 'mysql';
     $cfg['Servers'][$i]['connect_type'] = 'tcp';
   ```

   "?>"の直前に追加

   ```php
     $cfg['CheckConfigurationPermissions'] = false;
     ?>
   ```
7. http://phpmyadmin.local にアクセス
8. ID:root / PW:mysecretpw でログイン(**docker-compose.yml**にある環境変数**MYSQL_ROOT_PASSWORD**の値)

## その他 ##

### アクセスログ

ゲストOSにログインしたのち、

```bash
	cd /vagrant
    docker-compose logs
```

※MySQLコンテナ、PHP(FPM)コンテナのログ出力も表示されます。


### ホスト名とIPの関連付けについて

ホストOSのhostsファイルに任意のホスト名とゲストOSのIPを対応付けることでVagrant Host Managerを使用しなくても利用可能です。

### VagrantなしでDockerから起動する場合

1. git clone https://github.com/mistymagich/vagrant-docker-php.git
2. cd vagrant-docker-php
1. **docker-compose.yml**の**volumes**の左側の現在のフルパスに修正
2. docker-compose up
