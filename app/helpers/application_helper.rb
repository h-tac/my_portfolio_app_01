module ApplicationHelper
  def google_site_verification_meta_tag
    if controller_name == 'home' && action_name == 'index'
      tag.meta(name: 'google-site-verification', content: 'dlSCWEEGt9Ls0n_Q-5TWr_VQSzsm7ayg6ZFdrxzuhls')
    end
  end
end
