require 'digest/md5'
require 'uri'

module Rovi
  @shared_secret = "7Qbqyxz8TT"
  @api_key = "cc94xnqu4u5hwfqrdeq4umte"
  @base_url = "http://api.rovicorp.com"

  def self.md5
    Digest::MD5.hexdigest(@api_key + @shared_secret + Time.now.to_i.to_s)
  end

  def self.default_opts
    {
      :apikey => @api_key,
      :sig => md5,
      :format => 'xml'
    }
  end

  def self.album_lookup_url(artist, album)
    opts = { :query => "#{artist} #{album}",
             :facet => 'type',
             :size => '1',
             :entitytype => 'album'}.merge(default_opts)

    opts_string = opts.map{ |k,v| "#{k}=#{URI.escape(v)}"}.join('&')
    "#{@base_url}/search/v1/search?#{opts_string}"
  end

  def self.image_lookup_url(albumid)
    # http://api.rovicorp.com/data/v1/album/images?format=json&apikey=cc94xnqu4u5hwfqrdeq4umte&albumid=MW0002134155&sig=bd24b4fe03d297cd20148979a8e34e45
    opts = { :albumid => albumid }.merge(default_opts)

    opts_string = opts.map{ |k,v| "#{k}=#{URI.escape(v)}"}.join('&')
    "#{@base_url}/data/v1/album/images?#{opts_string}"
  end
end
