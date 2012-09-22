<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json

  def index
    @<%= plural_table_name %> = @<%= plural_table_name %>.page(params[:page])
    respond_with @<%= plural_table_name %>
  end

  def show
    respond_with @<%= singular_table_name %>
  end

  def new
    respond_with @<%= singular_table_name %>
  end

  def edit
    respond_with @<%= singular_table_name %>
  end

  def create
    if @<%= orm_instance.save %>
      flash.notice = t :model_create_successful, model: <%= class_name %>.model_name.human
    end
    respond_with @<%= singular_table_name %>
  end

  def update
    if @<%= orm_instance.save %>
      flash.notice = t :model_update_successful, model: <%= class_name %>.model_name.human
    end
    respond_with @<%= singular_table_name %>
  end

  def destroy
    @<%= orm_instance.destroy %>
    respond_with @<%= singular_table_name %>, location: <%= index_helper %>_path
  end
end
<% end -%>
