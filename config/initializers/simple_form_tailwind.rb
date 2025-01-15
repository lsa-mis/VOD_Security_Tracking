# frozen_string_literal: true

SimpleForm.setup do |config|
  # Default class for buttons
  config.button_class = 'inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-laitan_blue hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500'

  # Define the default class of the input wrapper of the boolean input.
  config.boolean_label_class = 'checkbox'

  config.wrappers :default, class: 'mb-4' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'block text-sm font-medium text-gray-700'
    b.use :input, class: 'mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md', error_class: 'border-red-500'
    b.use :error, wrap_with: { tag: :p, class: 'mt-2 text-sm text-red-600' }
    b.use :hint, wrap_with: { tag: :p, class: 'mt-2 text-sm text-gray-500' }
  end

  config.wrappers :vertical_boolean, tag: 'div', class: 'mb-4 flex items-start' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper tag: 'div', class: 'flex items-center h-5' do |ba|
      ba.use :input, class: 'focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded'
    end
    b.wrapper tag: 'div', class: 'ml-3 text-sm' do |bb|
      bb.use :label, class: 'block text-sm font-medium text-gray-700'
      bb.use :hint, wrap_with: { tag: :p, class: 'text-gray-500' }
      bb.use :error, wrap_with: { tag: :p, class: 'mt-2 text-sm text-red-600' }
    end
  end

  config.wrappers :vertical_collection, item_wrapper_class: 'flex items-center', item_label_class: 'ml-2 block text-sm font-medium text-gray-700', tag: 'div', class: 'my-4' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :legend_tag, tag: 'legend', class: 'text-sm font-medium text-gray-700', error_class: 'text-red-500' do |ba|
      ba.use :label_text
    end
    b.use :input, class: 'focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded', error_class: 'text-red-500'
    b.use :error, wrap_with: { tag: :p, class: 'mt-2 text-sm text-red-600' }
    b.use :hint, wrap_with: { tag: :p, class: 'mt-2 text-sm text-gray-500' }
  end

  config.wrappers :horizontal_form, tag: 'div', class: 'mb-4 flex flex-wrap items-center' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper :label_wrapper, tag: 'div', class: 'sm:w-1/4' do |ba|
      ba.use :label, class: 'block text-sm font-medium text-gray-700', error_class: 'text-red-500'
    end
    b.wrapper :input_wrapper, tag: 'div', class: 'sm:w-3/4' do |ba|
      ba.use :input, class: 'max-w-lg w-full shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border-gray-300 rounded-md', error_class: 'border-red-500'
      ba.use :error, wrap_with: { tag: :p, class: 'mt-2 text-sm text-red-600' }
      ba.use :hint, wrap_with: { tag: :p, class: 'mt-2 text-sm text-gray-500' }
    end
  end

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :default

  # Custom mappings for input types. This should be a hash containing a regexp
  # to match as key, and the input type that will be used when the field name
  # matches the regexp as value.
  config.input_mappings = { /count/ => :integer }

  # Custom wrappers for input types. This should be a hash containing an input
  # type as key and the wrapper that will be used for all inputs with specified type.
  config.wrapper_mappings = {
    boolean: :vertical_boolean,
    check_boxes: :vertical_collection,
    radio_buttons: :vertical_collection,
    horizontal_form: :horizontal_form
  }
end
