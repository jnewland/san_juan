module SanJuan
  @@roles = []

  def roles
    @@roles
  end

  def role(role, watches)
    @@roles << role

    namespace :god do

      unless @meta_tasks_defined
        namespace :all do
          desc "Describe the status of the running tasks on each server"
          task :status do
            san_juan.roles.each { |role| send(role).send(:status) }
          end

          desc "Start god"
          task :start do
            san_juan.roles.each { |role| send(role).send(:start) }
          end

          desc "Reloading God Config"
          task :reload do
            san_juan.roles.each { |role| send(role).send(:reload) }
          end

          desc "Start god interactively"
          task :start_interactive do
            san_juan.roles.each { |role| send(role).send(:start_interactive) }
          end

          desc "Quit god, but not the processes it's monitoring"
          task :quit do
            san_juan.roles.each { |role| send(role).send(:quit) }
          end

          desc "Terminate god and all monitored processes"
          task :terminate do
            san_juan.roles.each { |role| send(role).send(:terminate) }
          end
        end
      end
      @meta_tasks_defined = true

      namespace role do
        desc "Start god"
        task :start, :roles => role do
          sudo "#{san_juan.god_command} -c #{san_juan.configuration_path(current_path, role)}"
        end

        desc "Start god interactively"
        task :start_interactive, :roles => role do
          sudo "#{san_juan.god_command} -c #{san_juan.configuration_path(current_path, role)} -D"
        end

        desc "Reload the god config file"
        task :reload, :roles => role do
          sudo "#{san_juan.god_command} load #{san_juan.configuration_path(current_path, role)}"
        end

        desc "Quit god, but not the processes it's monitoring"
        task :quit, :roles => role do
          sudo "#{san_juan.god_command} quit"
        end

        desc "Terminate god and all monitored processes"
        task :terminate, :roles => role do
          sudo "#{san_juan.god_command} terminate"
        end

        desc "Describe the status of the running tasks"
        task :status, :roles => role do
          sudo "#{san_juan.god_command} status"
        end

        watches.each do |watch|
          namespace watch do
            %w(start restart stop unmonitor remove log).each do |command|
              desc "#{command.capitalize} #{watch}"
              task command, :roles => role do
                sudo "#{san_juan.god_command} #{command} #{watch}"
              end
            end
          end
        end

      end # end role namespace

    end #end god namespace
  end

  def configuration_path(current_path, role)
    fetch(:god_config_path, nil) || "#{current_path}/config/god/#{role}.god"
  end
  
  def god_command
    fetch(:god_command, nil) || "god"
  end

end
Capistrano.plugin :san_juan, SanJuan