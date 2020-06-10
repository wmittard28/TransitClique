require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride #middleware functionality, interpret any request _method
use CommentsController
use PostsController
use UsersController
run ApplicationController
