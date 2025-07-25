// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Application } from '@hotwired/stimulus'
import AutoSubmit from '@stimulus-components/auto-submit'

const application = Application.start()
application.register('auto-submit', AutoSubmit)