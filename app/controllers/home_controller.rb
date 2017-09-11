class HomeController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def get_entry
		@entries = Entry.all

		render :entry
	end

	def get_user
		@users = User.all

		render :user
	end

	def post_entry
		title = params[:title]
		content = params[:content]
		user_id = params[:user_id]

		user = User.find_by_id(user_id)
			unless user
				render json: { :message => 'user_id is invalid' }, status: 400
				return
			end

		entry = Entry.new
		entry.title = title
		entry.content = content
		entry.user_id = user_id
		entry.username = user.name

		if entry.valid?
			entry.save
			render json: { :message => 'post succeeded' }, status: 200
		else
			render json: { :message => 'post failed' }, status: 400
		end
	end

	def post_comment
		entry_id = params[:entry_id]
		text = params[:text]

		comment = Comment.new
		comment.entry_id = entry_id
		comment.text = text

		if comment.valid?
			comment.save
			render json: { :message => 'post succeeded' }, status: 200
		else
			render json: { :message => 'post failed' }, status: 400
		end
	end

	def post_source_url
		entry_id = params[:entry_id]
		title = params[:title]
		url = params[:url]

		source_article = SourceArticle.new
		source_article.entry_id = entry_id
		source_article.title = title
		source_article.url = url

		if source_article.valid?
			source_article.save
			render json: { :message => 'post succeeded' }, status: 200
		else
			render json: { :message => 'post failed' }, status: 400
		end
	end

	def post_user
		name = params[:name]
		email = params[:email]

		user = User.new
		user.name = name
		user.email = email

		if user.valid?
			user.save
			render json: { :message => 'post succeeded' }, status: 200
		else
			render json: { :message => 'post failed' }, status: 400
		end
	end

	def post_feature_image
    entry_id = params[:entry_id]
    image_url = params[:image_url]

   entry = Entry.find_by_id(entry_id)
    unless entry
      render json: { :message => 'entry_id is invalid' }, status: 400
      return
    end

   connection = Faraday.new(:url => image_url) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
    response = connection.get do |request|
    end
    image_file = response.body
		# puts image_file

   feature_image = FeatureImage.new
    feature_image.entry_id = entry.id
    # uploading image file
    file_name = '#{DateTime.now}.jpeg'
    temp_img_file = Tempfile.new(file_name)
    temp_img_file.binmode
    temp_img_file << image_file
    temp_img_file.rewind
    img_params = {:filename => file_name, :type => 'image/jpeg', :tempfile => temp_img_file}
    # create image
    feature_image.url = ActionDispatch::Http::UploadedFile.new(img_params)

		puts '#####################'
		puts img_params
		puts '#####################'

   if feature_image.valid?
      feature_image.save
      render json: { :message => 'post succeeded' }, status: 200
    else
      render json: { :message => 'feature_image is invalid' }, status: 400
    end

	end

	def post_feature_image_base64
		entry_id = params[:entry_id]
		image_file = params[:image_file]
		# uri_str = params[:image_url]

	 entry = Entry.find_by_id(entry_id)
		unless entry
			render json: { :message => 'entry_id is invalid' }, status: 400
			return
		end

	 feature_image = FeatureImage.new
		feature_image.entry_id = entry.id
		# uploading image file

	file_name = '#{DateTime.now}'

	image_data = split_base64(image_file)
	image_data_string = image_data[:data]
	image_data_binary = Base64.decode64(image_data_string)

	temp_img_file = Tempfile.new(file_name)
	temp_img_file.binmode
	temp_img_file << image_data_binary
	temp_img_file.rewind

	img_params = {:filename => "#{file_name}.#{image_data[:extension]}", :type => image_data[:type], :tempfile => temp_img_file}

		puts '###########Base64##########'
		puts img_params
		puts '#####################'

		feature_image.url = ActionDispatch::Http::UploadedFile.new(img_params)

	 if feature_image.valid?
			feature_image.save
			render json: { :message => 'post succeeded' }, status: 200
		else
			render json: { :message => 'feature_image is invalid' }, status: 400
		end

	end

	def split_base64(uri_str)
	if uri_str.match(%r{data:(.*?);(.*?),(.*)$})
		uri = Hash.new
		uri[:type] = $1
		uri[:encoder] = $2
		uri[:data] = $3
		uri[:extension] = $1.split('/')[1]
		return uri
	else
		return nil
	end
end

end
