# docker-php-env #

Docker(Docker Compose)で作るPHPの開発用実行環境

php,nginx,mysqlのコンテナを動かして、PHPを実行させる環境です。

## 必要なもの ##

* [Docker](https://www.docker.com/) バージョン 1.5.0 以上
* [Docker Compose](http://docs.docker.com/compose/)


Windows環境の場合、仮想OSとして[CoreOS](https://coreos.com/)を起動し、そこから起動させます。
Docker,Docker ComposeはCoreOSに含まれているのでインストールの必要はありません。

* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](https://www.vagrantup.com)
* Vagrantプラグイン

	* [Vagrant Host Manager](https://github.com/smdahlen/vagrant-hostmanager)

	  ```
	  vagrant plugin install vagrant-hostmanager
	  ```


## セットアップ ##

```bash
	git clone https://github.com/mistymagich/vagrant-docker-php.git
    cd docker-php-env
	docker-compose up
```

hostsファイルに以下を追加します

```
	127.0.0.1 sandbox.local
```


### Windowsの場合

```bash
	git clone https://github.com/mistymagich/vagrant-docker-php.git
    vagrant up
```

* Vagrant Host Managerによってhostsファイルの編集が行われるので、手動での編集は不要。
* hostsファイルがアンチウイルスソフトなどによって編集不可にされている場合があるので、あらかじめ解除しておく。



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

(Windowsの場合)
**Vagrantfile**の**config.hostmanager.aliases**に**phpmyadmin.local**を追加してvagrant up
(それ以外)
hostsファイルに以下を追加します

```
	127.0.0.1 phpmyadmin.local
```


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

### コンテナのログ出力

```bash
    docker-compose logs
```

Nginxコンテナ、MySQLコンテナ、PHP(FPM)コンテナのログ出力がまとめて表示されます。
windowsの場合は、ゲストOSにSSHログインしてコマンドを実行する

## 参考

* [kasperisager/phpstack](https://github.com/kasperisager/phpstack)
