#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../ruby_task_helper/files/task_helper'

class Fail2banUnbanipTask < TaskHelper
  def task(jail:, ips:, **_kwargs)
    command = ['fail2ban-client', 'set', jail, 'unbanip'] + ips

    pid = Process.spawn(*command)
    Process.wait(pid)

    nil
  end
end

Fail2banUnbanipTask.run if $PROGRAM_NAME == __FILE__
