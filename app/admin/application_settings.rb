ActiveAdmin.register ApplicationSetting do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :page, :description, :index_description, :form_instruction
  #
  # or
  #
  # permit_params do
  #   permitted = [:page, :description, :index_description, :form_instruction]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  actions :index, :show, :update, :edit
  config.filters = false

  index do
    selectable_column
    actions
    column :page
    column :description
    column :index_description do |appset|
      raw(appset.index_description)
    end
    column :form_instruction do |appset|
      raw(appset.form_instruction)
    end

  end

  show do
    attributes_table do 
      row :page do |item|
        item.page.titleize
      end
      row :description
      row :index_description do |item|
        raw(item.index_description)
      end
      if application_setting.page != "Dashboard" && application_setting.page != "Home"
        row :form_instruction do |item|
          raw(item.form_instruction)
        end
      end
    end
  end
  form do |f|
    f.inputs 'Application Settings' do
      # f.input :page
      li "Page: #{f.object.page}" unless f.object.new_record?
      f.input :description
      f.input :index_description, as: :quill_editor, input_html: { data:
                        { options:
                          { modules:
                            { toolbar:
                              [%w[bold italic underline strike],
                              [{ 'list': 'ordered' }, { 'list': 'bullet' }],
                              [{ 'align': [] }],
                              ['link'],
                              [{ 'size': ['small', false, 'large', 'huge'] }],
                              [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                              [{ 'indent': '-1' }, { 'indent': '+1' }],
                              [{ 'color': [] }, { 'background': [] }],
                              ['clean']] },
                            theme: 'snow' } } }, :hint => "Start any link you want to add with 'https://'"
      if application_setting.page != "Dashboard" && application_setting.page != "Home"
        f.input :form_instruction, as: :quill_editor, input_html: { data:
                          { options:
                            { modules:
                              { toolbar:
                                [%w[bold italic underline strike],
                                [{ 'list': 'ordered' }, { 'list': 'bullet' }],
                                [{ 'align': [] }],
                                ['link'],
                                [{ 'size': ['small', false, 'large', 'huge'] }],
                                [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                                [{ 'indent': '-1' }, { 'indent': '+1' }],
                                [{ 'color': [] }, { 'background': [] }],
                                ['clean']] },
                              theme: 'snow' } } }, :hint => "Start any link you want to add with 'https://'"
      end
    end
    f.actions
  end
end
