########################################################################
# ruby on railsを使用したブログ作成手順
########################################################################


# 新しいプロジェクトの作成
rails new board
cd board

# アプリケーションデータモデルの作成
rails g model Entry title:string content:string
rake db:migrate

# コントローラーの作成
rails g controller Home

  # config/routes.rb の設定
  vim config/routes.rb
    # getでentryがきた場合はhomeのget_entryメソッドにわたす
	  # 「get 'entry', :to => 'home#get_entry'」の記述

  # routes.rb で呼び出す関数の作成　(今回は app/controllers/home_controller.rb の中のget_entry)
    # def get_entry
    #   render :entry
    # end

# ビューの作成

  # slim.gemのインストール
  # gemfileへ「gem 'slim'」の記述
  bundle install

  # 拡張子の変更
  # app/views/layouts/application.html.slim への記述
    #「= yield」

  # app/views/home フォルダに「entry.slim」の作成
  # slim temprate engineを参照して「entry.slim」の作成
    # doctype html
    # html
    #   head
    #    title Blog
    #
    #   body
    #
    #         h1 title
    #         p content

# ローカルサーバーを立ち上げる
rails s
# get型のHTTPリクエストを「http://localhost:3000/entry」に要求した場合の挙動を確認する

  # config/routes.rb の設定
  # post 'entry', :to => 'home#post_entry'

  # post型のリクエストに対してのコントローラーを作成する

    # app/controllers/home_controller.rbの編集

    #
    # skip_before_filter :verify_authenticity_token
    #
    # def post_entry
    #   title = params[:title]
    #   content = params[:content]
    #
    #   entry = Entry.new
    #   entry.title = title
    #   entry.content = content
    #
    #   if entry.valid?
    #     entry.save
    #     render json: { :message => 'post succeeded' }, status: 200
    #   else
    #     render json: { :message => 'post failed' }, status: 400
    #   end
    # end

# ローカルサーバーを立ち上げる
rails s
# Post型のHTTPリクエストを「http://localhost:3000/entry」送信した場合の挙動を確認する

#  app/controllers/home_controller.rb のget_entry　の再定義

  # def get_entry
  #   @entries = Entry.all
  #   render :entry
  # end

# entry.slim」の拡張

  # doctype html
  # html
  #   head
  #     title Blog
  #
  #   body
  #
  #       - @entries.each do |entry|
  #         h1 #{entry.title}
  #         p #{entry.content}


# get型のHTTPリクエストを「http://localhost:3000/entry」送信した場合の挙動を確認する
#  →　HTTPリクエストで投稿したタイトルとコンテンツが全て表示されればOK!

########################################################################
# RDB　作成手順
########################################################################

rails g model User name:string email:string

rake db:migrate

rails g migration AddUserRefToEntries user:references

rake db:migrate

# entry.rbの拡張

 # class Entry < ApplicationRecord
 #   belongs_to :user
 # end

# user.rbの拡張

 # class User < ApplicationRecord
 #    validates_presence_of :name
 #    has_many :entries, dependent: :destroy
 #  end

 # entry.rbの拡張

  # class Entry < ApplicationRecord
  #   has_one :feature_image, dependent: :destroy
  # end

 # feature_image.rbの拡張

   # class FeatureImage < ApplicationRecord
   #   validates_presence_of :url
   #   mount_uploader :url, FeatureImageUploader
   #   belongs_to :entry
   # end

 # config/routes.rb の設定
 vim config/routes.rb
   # post 'user', :to => 'home#post_user'


# entry.slim」の拡張

 #    - @entries.each do |entry|
 #      h1 #{entry.title}
 #      p #{entry.content}
 #      - if entry.feature_image
 #          img src="#{entry.feature_image.url}"
 #
 #      - entry.comments.each do |comment|
 #        p #{comment.text}
