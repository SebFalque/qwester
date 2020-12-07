require "qwester/engine"
require 'acts_as_list'
require 'paperclip'
require 'random_string'
require_relative 'rails/actionpack/lib/action_controller/base'

module Qwester
  
  def self.active_admin_load_path
    File.expand_path("active_admin/admin", File.dirname(__FILE__))
  end
  
  def self.active_admin_menu
    if @active_admin_menu == 'none'
      return nil
    elsif @active_admin_menu
      @active_admin_menu
    else
      'Qwester'
    end
  end
  
  def self.active_admin_menu=(menu)
    @active_admin_menu = menu
  end
  
  def self.session_key
    @session_key || :qwester_answer_store
  end
  
  def self.session_key=(key)
    @session_key = key
  end

  def self.rails_version
    @rails_version ||= Rails.version.split('.').first.to_i if defined? Rails
  end

  def self.rails_three?
    rails_version.to_i >= 3
  end
  
end
