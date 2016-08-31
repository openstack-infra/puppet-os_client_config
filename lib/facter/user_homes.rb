# User home directories

require 'etc'

Etc.passwd do |pwentry|
    Facter.add( "home_#{pwentry.name}" ) do
        setcode do
            pwentry.dir
        end
    end
end
