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

// Trix editor setup - make sure this runs before requiring trix
if (typeof window.customElements.get('trix-editor') === 'undefined') {
  let Trix = require("trix")
  require("@rails/actiontext")

  // Make Trix available globally
  window.Trix = Trix
}

document.addEventListener('trix-file-accept', function(event) {
  // Configure file upload restrictions if needed
  // event.preventDefault() // Uncomment to disable file uploads
})

// Initialize Trix uploads
addEventListener("trix-attachment-add", function(event) {
  if (event.attachment.file) {
    return uploadAttachment(event.attachment)
  }
})

// Flatpickr
import flatpickr from "flatpickr"
window.flatpickr = flatpickr

function uploadAttachment(attachment) {
  // You can customize upload behavior here if needed
  uploadFileAttachment(attachment)
}

function uploadFileAttachment(attachment) {
  const file = attachment.file
  const form = new FormData()
  form.append("Content-Type", file.type)
  form.append("file", file)

  const xhr = new XMLHttpRequest()
  xhr.open("POST", "/rails/active_storage/direct_uploads", true)
  xhr.setRequestHeader("X-CSRF-Token", getMetaValue("csrf-token"))

  xhr.upload.onprogress = function(event) {
    const progress = event.loaded / event.total * 100
    attachment.setUploadProgress(progress)
  }

  xhr.onload = function() {
    if (xhr.status === 200) {
      const data = JSON.parse(xhr.responseText)
      attachment.setAttributes({
        url: data.service_url,
        href: data.service_url
      })
    }
  }

  xhr.send(form)
}

function getMetaValue(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`)
  return element.getAttribute("content")
}
