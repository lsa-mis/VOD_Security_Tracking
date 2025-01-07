import { application } from "./application"

// Import and register all your controllers from the importmap under controllers/*
import {
  Alert,
  Autosave,
  Dropdown,
  Modal,
  Tabs,
  Popover,
  Toggle,
  Slideover
} from "tailwindcss-stimulus-components"

// Register Stimulus Components
if (Alert) application.register('alert', Alert)
if (Autosave) application.register('autosave', Autosave)
if (Dropdown) application.register('dropdown', Dropdown)
if (Modal) application.register('modal', Modal)
if (Tabs) application.register('tabs', Tabs)
if (Popover) application.register('popover', Popover)
if (Toggle) application.register('toggle', Toggle)
if (Slideover) application.register('slideover', Slideover)

// Eager load all controllers defined in the import map under controllers/**/*_controller
const controllers = import.meta.glob('./**/*_controller.js', { eager: true })
for (const path in controllers) {
  const name = path.match(/\.\/(.+)_controller\.js$/)[1].replaceAll('/', '--')
  application.register(name, controllers[path].default)
}
