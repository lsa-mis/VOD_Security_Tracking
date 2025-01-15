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

// Import all controllers
import InfotoggleController from "./infotoggle_controller"
import FiltersController from "./filters_controller"
import LegacyosController from "./legacyos_controller"
import ReportController from "./report_controller"
import SensitivedsController from "./sensitiveds_controller"
import FlatpickrController from "./flatpickr_controller"

// Register them with Stimulus
application.register("infotoggle", InfotoggleController)
application.register("filters", FiltersController)
application.register("legacyos", LegacyosController)
application.register("report", ReportController)
application.register("sensitiveds", SensitivedsController)
application.register("flatpickr", FlatpickrController)
