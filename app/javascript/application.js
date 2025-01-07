// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

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
import flatpickr from "flatpickr"
window.flatpickr = flatpickr
