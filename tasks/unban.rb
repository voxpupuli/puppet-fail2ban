#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../ruby_task_helper/files/task_helper'

class Fail2banUnbanTask < TaskHelper
  def task(ips:, **_kwargs)
    command = %w[fail2ban-client unban] + ips

    pid = Process.spawn(*command)
    Process.wait(pid)

    nil
  end
end

Fail2banUnbanTask.run if $PROGRAM_NAME == __FILE__
