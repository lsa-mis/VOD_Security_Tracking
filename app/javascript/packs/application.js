// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("trix")
require("@rails/actiontext")

import "@hotwired/turbo-rails"
import "channels"
import "controllers"
import * as ActiveStorage from "@rails/activestorage"
import Rails from "@rails/ujs"

import "../layouts/application.sass"
import "../layouts/forms.sass"
// import "../../assets/stylesheets/actiontext.scss"
import "../layouts/instructions.sass"
import "@fortawesome/fontawesome-free/css/all"

import './pagy.js.erb'

Rails.start()
ActiveStorage.start()

const images = require.context('../images', true)
