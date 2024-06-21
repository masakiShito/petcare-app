# ペットケアアプリ

このプロジェクトは Django を使用して構築されたペットケアアプリケーションです。

## 前提条件

- Python 3.x
- Django 3.x 以降
- Virtualenv（任意ですが推奨）

## インストール

1. リポジトリをクローンします:

   ```sh
   git clone https://github.com/masakishito/petcare-app.git
   cd petcare-app
   cd backend
   ```

2. 仮想環境を作成してアクティベートします（任意ですが推奨）:

   ```sh
   python -m venv env
   source env/bin/activate  # Windowsの場合は `env\Scripts\activate`
   ```

3. 必要な依存関係をインストールします:
   ※現在のところ使用していない

   ```sh
   pip install -r requirements.txt
   ```

4. データベースをセットアップするためにマイグレーションを適用します:

   ```sh
   python manage.py migrate
   ```

5. Django 管理パネルにアクセスするためのスーパーユーザーを作成します:

   ```sh
   python manage.py createsuperuser
   ```

6. 静的ファイルを収集します:
   ```sh
   python manage.py collectstatic
   ```

## 開発サーバーの起動

開発サーバーを起動するには、次のコマンドを使用します:

```sh
python manage.py runserver
```
