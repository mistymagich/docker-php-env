# vagrant-docker-php README #

Vagrant+Dockerで作るPHPの実行環境

php,nginx,mysqlのコンテナを動かして、PHPを実行させる環境です。

vagrantとvirtualboxもしくはdockerがインストールされているlinuxから起動できます。

## 必要なもの ##

* Vagrantを使う方式

	* [VirtualBox](https://www.virtualbox.org)
	* [Vagrant](https://www.vagrantup.com)
	* Vagrantプラグイン

		* [Vagrant Host Manager](https://github.com/smdahlen/vagrant-hostmanager)

		  ```
		  vagrant plugin install vagrant-hostmanager
		  ```

* Dockerから起動する方式

	* [Docker](https://www.docker.com/)がインストールされたLinux
      バージョン 1.5.0 以上


## セットアップ ##

* Vagrantを使う方式

	```
		> git clone https://github.com/mistymagich/vagrant-docker-php.git
		> cd vagrant-docker-php
		> vagrant up
	```

* Dockerから起動する方式

	```bash
		$ git clone https://github.com/mistymagich/vagrant-docker-php.git
		$ cd vagrant-docker-php
		$ chmod +x *.sh
        $ sudo echo '127.0.0.1 sandbox.local' >> /etc/hosts
		$ sudo ./docker-run.sh
	```

    Ubuntu/Debianでdockerコマンドがdocker.io[^1]になっている場合、docker-run.shの

    ```bash
    DOCKER=docker
    ```

    を

    ```bash
    DOCKER=docker.io
    ```

    に変更したのち実行する。


[^1]: Ubuntu/Debianの場合、dockerコマンドがdocker.ioになっているため、[いまさら聞けないDocker入門（2）：ついに1.0がリリース！ Dockerのインストールと主なコマンドの使い方 (1/3) - ＠IT](http://www.atmarkit.co.jp/ait/articles/1406/10/news031.html)にあるようにしてdockerコマンドを利用できるようにする方法もあります。


正常に起動できれば、ブラウザで http://sandbox.local でアクセスするとPHPInfoが表示されます。

MySQLコンテナとの接続サンプルは http://sandbox.local/dbconnect.php にあります。


## 構造 ##

### Nginxコンテナ ###

コンテナ名：sandbox-nginx

[公式Nginxコンテナ](https://registry.hub.docker.com/_/nginx/)をもとに、ホスト名sandbox.localに対して、PHPコンテナを参照する設定追加しています。
ドキュメントルートはsrc/public
拡張子がPHPならPHPコンテナにあるPHP-FPMを通して実行されます。

### MySQLコンテナ ###

コンテナ名：sandbox-mysql

[公式MySQLコンテナ](https://registry.hub.docker.com/_/mysql/)をそのまま利用しています。

データの永続化はしていません。

docker-run.sh実行時にsrcディレクトリにあるinit.sqlを実行することで、データベース・テーブル・データのインポートを行っています。

sanbox.localに対して3306にアクセスすることでMySQLコンテナにアクセスできます。

ユーザー名はroot、パスワードはdocker-run.shでMySQLコンテナ起動時にMYSQL_ROOT_PASSWORDで指定している値です。(編集していない場合、mysecretpw)

### PHP(FPM)コンテナ ###

コンテナ名：sandbox-php

[公式PHPコンテナ](https://registry.hub.docker.com/_/php/)のFPMをもとに、以下のモジュールを追加しています。

* pdo
* pdo_mysql
* gd
* mysqli
* mcrypt
* mbstring
* iconv

### 関係図 ###

![関係図](https://raw.githubusercontent.com/mistymagich/vagrant-docker-php/master/relation.png)

PHP(FPM)コンテナはホスト名mysqlでMySQLコンテナにアクセスできます。
Nginxコンテナはホスト名phpでPHP(FPM)コンテナを参照しています。

## PHPMyAdminのインストールサンプル ##

1. [PHPMyAdmin](http://www.phpmyadmin.net/home_page/downloads.php)をダウンロード
2. 解凍して、中にあるPHPファイルをsrc/publicにコピー（すでにあるファイルは削除する）
3. config.sample.incをconfig.incにリネーム
4. config.incを編集

   ホスト名を変更

   ```diff
     /* Authentication type */
     $cfg['Servers'][$i]['auth_type'] = 'cookie';
     /* Server parameters */
    -$cfg['Servers'][$i]['host'] = 'localhost';
    +$cfg['Servers'][$i]['host'] = 'mysql';
     $cfg['Servers'][$i]['connect_type'] = 'tcp';
   ```

   末尾に追加

   ```php
     $cfg['CheckConfigurationPermissions'] = false;
   ```
5. http://sandbox.localにアクセス
6. ID:root / PW:mysecretpw (docker-run.shのMySQLコンテナ起動時のMYSQL_ROOT_PASSWORDで指定している値)

## その他 ##

* docker-run.sh実行時にすべてのコンテナを削除します。
* コンテナが正常に動かない場合、docker ps -aでコンテナIDを調べ、docker logs コンテナID で原因となるメッセージが出力されることがあります。


