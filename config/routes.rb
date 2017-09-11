Rails.application.routes.draw do

#getでentryがきた場合はhomeのget_entryメソッドにわたす
	get 'entry', :to => 'home#get_entry'

	get 'user', :to => 'home#get_user'

	post 'entry', :to => 'home#post_entry'

	post 'comment', :to => 'home#post_comment'

	post 'image', :to => 'home#post_feature_image'
	post 'image2', :to => 'home#post_feature_image_base64'

	post 'user', :to => 'home#post_user'

	post 'source', :to => 'home#post_source_url'

end
