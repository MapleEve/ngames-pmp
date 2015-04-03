require 'account_controller'
require 'issues_controller'
require 'json'
require 'uri'

class RedmineOauthController < AccountController
  include Helpers::MailHelper
  include Helpers::Checker
  # 请求 token 的方法
  def oauth_ngames
    if Setting.plugin_redmine_omniauth_ngames[:oauth_authentification] && User.current.admin?
      session[:back_url] = params[:back_url]
      redirect_to oauth_client.auth_code.authorize_url(:redirect_uri => oauth_ngames_callback_url, :scope => scopes)
    else
      flash[:error] = l(:notice_access_denied)
      password_authentication
    end
  end

  # 登陆的方法
  def login_ngames
    if Setting.plugin_redmine_omniauth_ngames[:oauth_authentification]
      session[:verify] = params[:verify]
      if session[:verify] =~ /\.98:3000/
        callback_url = URI.escape('http://60.191.1.98:3000/loginhash')
      elsif session[:verify] =~ /\.com:3000/
        callback_url = URI.escape('http://dev.esazx.com:3000/loginhash')
      elsif session[:verify] =~ /esazx\.com\//
        callback_url = URI.escape('http://esazx.com/loginhash')
      elsif session[:verify] =~ /10\.10\.1\.79/
        callback_url = URI.escape('http://10.10.1.79/loginhash')
      else
        callback_url = URI.escape('http://esazx.com:3333/loginhash')
      end
      redirect_to oauth_client.auth_code.login_url(:callback_url => callback_url)
    else
      flash[:error] = l(:notice_access_denied)
      password_authentication
    end
  end

  def adminauth
    if User.current.admin? && Setting.plugin_redmine_omniauth_ngames[:adminauth]
      successful_authentication(User.find_or_initialize_by_mail(params[:u]))
    else
      flash[:error] = l(:notice_access_denied)
      redirect_to signin_path
    end
  end


  def oauth_ngames_callback
    if params[:error]
      flash[:error] = l(:notice_access_denied)
      redirect_to signin_path
    else
      # 开始通过 token 地址获取 token
      token = oauth_client.auth_code.get_token(params[:code])
      info = JSON.parse(token.to_s)
      if info && info["code"] == 0
      	# 拿取实际access token
        @settings[:access_token] = info['data']['access_token']
        @settings[:access_token].save
        flash[:notice] = info['data']['access_token']
        redirect_to signin_path
      else
        flash[:error] = token #l(:notice_unable_to_obtain_ngames_credentials)
        redirect_to signin_path
      end
    end
  end

# 登陆的回调处理
  def loginhash
    if params[:account] && !User.current.logged?
      @id = settings[:client_id]
      @secret = settings[:client_secret]
      params[:client_id] = settings[:client_id]
      params[:code] = settings[:access_token]
      params[:time] = Time.now.to_i.to_s
      params[:signature_method] = 'md5'
      params[:signature] = Digest::MD5.hexdigest(Time.now.to_i.to_s<<@id<<@secret)
      info = oauth_client.auth_code.get_info(params)
      info = JSON.parse(info)
      if info && info["code"] == 0
        try_to_login info
      else
        flash[:error] = info['message']
        redirect_to signin_path
      end
    else
      flash[:error] = l(:notice_access_denied)
      redirect_to signin_path
    end
  end



# 发送 QQ Tip 的处理
  def issuetip
    if params[:tipuser] && User.current.logged? && User.find_by_id(params[:uid]).mail
      @id = settings[:client_id]
      @secret = settings[:client_secret]
      params[:client_id] = settings[:client_id]
      params[:code] = settings[:access_token]
      params[:time] = Time.now.to_i.to_s
      params[:signature_method] = 'md5'
      params[:signature] = Digest::MD5.hexdigest(Time.now.to_i.to_s<<@id<<@secret)
      params[:tips_title] = l(:field_issue)<<' #'<<params[:c3]<<l(:isassigned_to)<<params[:tipuser]
      params[:tips_content] = params[:tips_content]<<' - '<<l(:field_priority)<<': '<<params[:c1]<<' - '<<l(:field_due_date)<<': '<<params[:c2]<<' By:'<<User.current.name
      params[:display_time] = 0
      params[:receive_type] = 0
      params[:receivers] = (User.find_by_id(params[:uid]).mail.split('.')[1] =~ /^(\w)@(ngames)$/i) ? User.find_by_id(params[:uid]).mail.split('@')[0] : User.find_by_id(params[:uid]).login
      info = oauth_client.auth_code.sendqq_tips(params)
      info = JSON.parse(info)
      if info && info["code"] == 0
        flash[:notice] = l(:notify_success)
        redirect_to issue_path(params[:c3])
      else
        flash[:error] = info['message']
        redirect_to issue_path(params[:c3])
      end
    else
      flash[:error] = l(:notice_access_denied)
      redirect_to issue_path(params[:c3])
    end
  end

# 开始用拿到的信息尝试注册或者登陆
  def try_to_login info
   user = User.find_or_initialize_by_mail(info['data']["email"])
    if user.new_record?
      # 处理关闭注册的情况
      redirect_to(home_url) && return unless Setting.self_registration?
      # 后台创建新用户
      user.firstname = info['data']["account"].split('.')[0]
      user.lastname = info['data']["realname"]
      user.mail = info['data']["email"]
      user.login = info['data']["account"]
      user.mail_notification = 'only_my_events'
      user.linkedin = info['data']["qq"]
      user.identity_url = info['data']["p_dept_id"]
      user.phone = info['data']["mobile"]
      if info['data']["gender"].to_i > 0
        user.gender = 0
      else
        user.gender = 1
      end
      user.random_password
      user.register

      case Setting.self_registration
      when '1'
        register_by_email_activation(user) do
          onthefly_creation_failed(user)
        end
      when '3'
        register_automatically(user) do
          onthefly_creation_failed(user)
        end
      else
        register_manually_by_administrator(user) do
          onthefly_creation_failed(user)
        end
      end
    else
      # 如果用户存在的情况
      if user.active?
        user.firstname = info['data']["account"].split('.')[0]
        user.lastname = info['data']["realname"]
        user.mail = info['data']["email"]
        user.login = info['data']["account"]
        user.mail_notification = 'only_my_events'
        user.linkedin = info['data']["qq"]
        user.identity_url = info['data']["p_dept_id"]
        if info['data']["gender"].to_i > 0
          user.gender = 0
        else
          user.gender = 1
        end
        # 如果手机没变就不更新状态, 如果手机变了就更新所有状态
        if user.phone == info['data']["mobile"]
          # 依照 Email 地址成功登陆
          successful_authentication(user)
        else
          user.phone = info['data']["mobile"]
          # 更新所有用户信息之后登陆
          user.save
          successful_authentication(user)
        end
      else
        # 本版本处理用户需要后台进行验证通过的情况
        if Redmine::VERSION::MAJOR > 2 or
          (Redmine::VERSION::MAJOR == 2 and Redmine::VERSION::MINOR >= 4)
          account_pending(user)
        else
          account_pending
        end
      end
    end
  end

  def oauth_client
    @client ||= OAuth2::Client.new(settings[:client_id], settings[:client_secret],
      :site => 'http://oa.ngames.cn/',
      :authorize_url => '/oauth/v2/authorize',
      :token_url => '/oauth/v2/token',
      :login_url => '/login',
      :hashkey_url => '/oauth/v2/verifyhashkey',
      :qqtip_url => '/oauth/api/sendqq'
      )
  end

  def settings
    @settings ||= Setting.plugin_redmine_omniauth_ngames
  end

  def scopes
    'sendbroadcast;sendqq;userinfo;userlist'
  end
end
