<?php

namespace Drupal\tridugdemo\Installer\Form;

use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Url;

/**
 * Provides the site configuration form.
 */
class ProfileConfigureForm extends ConfigFormBase {

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'tridugdemo_extra_settings_form';
  }

  /**
   * {@inheritdoc}
   */
  protected function getEditableConfigNames() {
    return [];
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {

    $form['#title'] = $this->t('Configure extra settings');

    $config = $this->config('google_analytics.settings');

    $form['google_analytics_account'] = [
      '#default_value' => $config->get('account'),
      '#description' => $this->t('This ID is unique to each site you want to track separately, and is in the form of UA-xxxxxxx-yy. To get a Web Property ID, <a href=":analytics">register your site with Google Analytics</a>, or if you already have registered your site, go to your Google Analytics Settings page to see the ID next to every site profile. <a href=":webpropertyid">Find more information in the documentation</a>.', [':analytics' => 'http://www.google.com/analytics/', ':webpropertyid' => Url::fromUri('https://developers.google.com/analytics/resources/concepts/gaConceptsAccounts', ['fragment' => 'webProperty'])->toString()]),
      '#maxlength' => 20,
      '#placeholder' => 'UA-',
      '#required' => TRUE,
      '#size' => 20,
      '#title' => $this->t('Web Property ID'),
      '#type' => 'textfield',
    ];

    $form['actions'] = ['#type' => 'actions'];
    $form['actions']['save'] = [
      '#type' => 'submit',
      '#value' => $this->t('Save and continue'),
      '#button_type' => 'primary',
      '#submit' => ['::submitForm'],
    ];

    return $form;
  }


  /**
   * {@inheritdoc}
   */
  public function validateForm(array &$form, FormStateInterface $form_state) {

    parent::validateForm($form, $form_state);

    // Trim some text values.
    $form_state->setValue('google_analytics_account', trim($form_state->getValue('google_analytics_account')));

    // Replace all type of dashes (n-dash, m-dash, minus) with normal dashes.
    $form_state->setValue('google_analytics_account', str_replace(['–', '—', '−'], '-', $form_state->getValue('google_analytics_account')));

    if (!preg_match('/^UA-\d+-\d+$/', $form_state->getValue('google_analytics_account'))) {
      $form_state->setErrorByName('google_analytics_account', $this->t('A valid Google Analytics Web Property ID is case sensitive and formatted like UA-xxxxxxx-yy.'));
    }

  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $config = $this->configFactory()->getEditable('google_analytics.settings');
    $config
      ->set('account', $form_state->getValue('google_analytics_account'))
      ->save();
    parent::submitForm($form, $form_state);
  }

}
