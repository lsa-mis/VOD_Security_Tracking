// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import Rails from "@rails/ujs"
Rails.start()

// Stimulus setup
import { Application } from "@hotwired/stimulus"
const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

// Trix editor
import "trix"
import "@rails/actiontext"

// Flatpickr
import "flatpickr"
import "stimulus-flatpickr"
