// Menu toggle functionality
(function() {
  'use strict';
  
  function toggleMenuSection(button) {
    const parent = button.closest('li.group');
    if (parent) {
      if (parent.dataset.open) {
        delete parent.dataset.open;
      } else {
        parent.dataset.open = "";
      }
      return true;
    }
    return false;
  }

  function initMainMenu() {
    const mainMenu = document.getElementById('main-menu');
    if (!mainMenu) {
      console.log('ActiveAdmin menu: main-menu not found');
      return;
    }

    // Remove old delegation handler if exists
    if (mainMenu._menuClickHandler) {
      mainMenu.removeEventListener('click', mainMenu._menuClickHandler, true);
    }

    // Create delegation handler
    mainMenu._menuClickHandler = function(event) {
      // Check if click is on a menu button or its children
      const button = event.target.closest('[data-menu-button]');
      
      if (button) {
        event.preventDefault();
        event.stopPropagation();
        
        if (toggleMenuSection(button)) {
          console.log('ActiveAdmin menu: Toggled menu section');
        }
        return false;
      }
    };

    // Add delegation listener with capture
    mainMenu.addEventListener('click', mainMenu._menuClickHandler, true);
    
    // Also add direct listeners to all buttons
    const buttons = mainMenu.querySelectorAll('[data-menu-button]');
    buttons.forEach(button => {
      // Remove old listener if exists
      if (button._directHandler) {
        button.removeEventListener('click', button._directHandler);
      }
      
      // Create and store new handler
      button._directHandler = function(event) {
        event.preventDefault();
        event.stopPropagation();
        toggleMenuSection(button);
      };
      
      button.addEventListener('click', button._directHandler, false);
    });
    
    console.log(`ActiveAdmin menu: Initialized with ${buttons.length} menu buttons`);
  }

  // Initialize on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initMainMenu);
  } else {
    initMainMenu();
  }

  // Re-initialize after Turbo navigates
  document.addEventListener('turbo:load', initMainMenu);
  document.addEventListener('turbo:render', initMainMenu);
  
  // Fallback for non-Turbo
  window.addEventListener('load', initMainMenu);
  
  // Also watch for menu changes with MutationObserver
  if (typeof MutationObserver !== 'undefined') {
    const observer = new MutationObserver(function(mutations) {
      const mainMenu = document.getElementById('main-menu');
      if (mainMenu) {
        // Check if new buttons were added
        const buttons = mainMenu.querySelectorAll('[data-menu-button]');
        buttons.forEach(button => {
          if (!button._directHandler) {
            button._directHandler = function(event) {
              event.preventDefault();
              event.stopPropagation();
              toggleMenuSection(button);
            };
            button.addEventListener('click', button._directHandler, false);
          }
        });
      }
    });
    
    // Start observing when DOM is ready
    if (document.body) {
      observer.observe(document.body, {
        childList: true,
        subtree: true
      });
    } else {
      document.addEventListener('DOMContentLoaded', function() {
        if (document.body) {
          observer.observe(document.body, {
            childList: true,
            subtree: true
          });
        }
      });
    }
  }
})();
