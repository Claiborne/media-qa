require 'github/markup'
GitHub::Markup.render(file, File.read(file))

''italic test''
'''bold test'''