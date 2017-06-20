require "faraday"
require "json"
require "pp"
require "base64"
require "open-uri"
# require "FileUtils"

class ApplicationController

  def hello
   render html: "hello, world!"
  end

  def save_image(url)
  # ready filepath
  fileName = File.basename(url)
  dirName = "/Users/Kazuya/Documents/Work/Bootcamp/Client/ruby_client/api-client-test/"
  filePath = dirName + fileName

  # create folder if not exist
  FileUtils.mkdir_p(dirName) unless FileTest.exist?(dirName)

  # write image adata
    open(filePath, 'wb') do |output|
      open(url) do |data|
        output.write(data.read)
      end
    end
    return fileName
  end

  def gclVision

    ##########################################
    # 画像ファイルの保存
    ##########################################

    imageurl = "http://vps6-d.kuku.lu/files/20170616-0050_6baabbbbcaad400ad3b80504f305985f.jpg"
    imagepath = save_image(imageurl)

    ##########################################
    # 画像ファイルのBase64化
    ##########################################

    original = File.open(imagepath, "r+b") # 読み込み
    readimage = Base64.strict_encode64(original.read)
    original.close

    # pp readimage

    ##########################################
    # jsonの作成
    ##########################################

    featuretype = 'LABEL_DETECTION'

    json_file_path = 'request64.json'

    file = File.open(json_file_path)
    hash = JSON.load(file)
    # pp hash
    json_str = JSON.dump(hash)
    # pp json_str

    json_str.gsub!(/BASE64/, readimage)
    json_str.gsub!(/TYPE/, featuretype)

    ##########################################
    # faradayコネクションの作成
    ##########################################

    # gcl Vision api url
    # apiUrl = "vision.googleapis.com/v1/images:annotate"
    apiUrl = "vision.googleapis.com"
    uri = "https://" + apiUrl

    conn = Faraday::Connection.new(:url => uri) do |builder|
     ## URLをエンコードする
      builder.use Faraday::Request::UrlEncoded
     ## ログを標準出力に出したい時(本番はコメントアウトでいいかも)
      builder.use Faraday::Response::Logger
     ## アダプター選択（選択肢は他にもあり）
      builder.use Faraday::Adapter::NetHttp

    end

    ##########################################
    # faradayからpostリクエスト
    ##########################################

    #gcp apiKey
    apiKey = "AIzaSyApbivNJfHiy6tW-X2JPZmtseUwfm6D99c"
    requrl = "/v1/images:annotate" + "?key=" + apiKey



    res = conn.post do |req|
       req.url requrl
       req.headers['Content-Type'] = 'application/json'
       req.body = json_str
    end

     body = JSON.parse(res.body)
     pp body

  end


end


p "---------------------------------------------"
ac = ApplicationController.new
ac.gclVision
# imageurl = "http://vps6-d.kuku.lu/files/20170616-0050_6baabbbbcaad400ad3b80504f305985f.jpg"
# text = ac.save_image(imageurl)
# puts text
p "---------------------------------------------"
