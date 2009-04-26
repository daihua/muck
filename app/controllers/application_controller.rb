class ApplicationController < ActionController::Base
  
  include SslRequirement
  
  layout 'default'
    
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
   
  before_filter :set_body_class
  
  protected

  # only require ssl if we are in production
  def ssl_required?
    return ENV['SSL'] == 'on' ? true : false if defined? ENV['SSL']
    return false if local_request?
    return false if RAILS_ENV == 'test'
    ((self.class.read_inheritable_attribute(:ssl_required_actions) || []).include?(action_name.to_sym)) && (RAILS_ENV == 'production' || RAILS_ENV == 'staging')
  end
  
  def setup_paging
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1
    @per_page = (params[:per_page] || (Rails.env=='test' ? 1 : 40)).to_i
  end

  # Automatically respond with 404 for ActiveRecord::RecordNotFound
  def record_not_found
    render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
  end
  
  # uncomment this method if you would like to add directories to cms lite
  #def setup_cms_lite
    # this will be called by the cms lite plugin
    # prepend_cms_lite_path(File.join(RAILS_ROOT, 'content', 'help'))
  #end
  private
  def set_body_class
    @body_class ||= "body"
  end 

end
