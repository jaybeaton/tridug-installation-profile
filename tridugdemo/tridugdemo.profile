<?php

/**
 * @file
 * Enables modules and site configuration for the TriDUG Demo installation profile.
 */

use Drupal\Core\Config\FileStorage;
use Drupal\Core\Form\FormStateInterface;

/**
 * Implements hook_install_tasks().
 */
function tridugdemo_install_tasks() {
  $tasks = [];
  $tasks['tridugdemo_post_install_tasks'] = [
    'display_name' => t('TriDUG Demo installation tasks'),
    'type' => 'normal',
  ];
  $tasks['tridugdemo_extra_settings_form'] = [
    'display_name' => t('TriDUG Demo extra settings'),
    'type' => 'form',
    'function' => 'Drupal\tridugdemo\Installer\Form\ProfileConfigureForm',
  ];
  return $tasks;
}

function tridugdemo_post_install_tasks() {

  $config_path = drupal_get_path('profile', 'tridugdemo') . '/config/post-install';
  $source = new FileStorage($config_path);
  $config_storage = \Drupal::service('config.storage');

  foreach ($source->listAll() as $item) {
    $config_storage->write($item, $source->read($item));
  } // Loop thru items.

  drupal_flush_all_caches();
  drupal_set_message(t('TriDUG Demo installation tasks complete.'));

}


/**
 * Implements hook_form_FORM_ID_alter() for install_configure_form().
 */
function tridugdemo_form_install_configure_form_alter(&$form, FormStateInterface $form_state) {
  $form['regional_settings']['site_default_country']['#default_value'] = 'US';
  $form['regional_settings']['date_default_timezone']['#default_value'] = 'America/New_York';
}

