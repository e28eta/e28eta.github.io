---
layout: single
title: Blogging with Jekyll (+ puma-dev, gh-pages, cloudflare)
tags:
- blog
- jekyll
- puma-dev
- gh-pages
- cloudflare
- minimal mistakes
toc: true
toc_sticky: true
date: 2022-02-15 10:15 -0800
---
I'd successfully resisted for 5 years, but here comes the post where I describe this blog's current technology stack. The short answer is that I'm using GitHub Pages, but I've layered enough complexity onto it that I want to write it down for future me.

# [<i class="fab fa-fw fa-github" aria-hidden="true"></i> GitHub Pages](https://pages.github.com)

> GitHub Pages is a static site hosting service that takes HTML, CSS, and JavaScript files straight from a repository on GitHub, optionally runs the files through a build process, and publishes a website. [[ref]](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages#about-github-pages)

> We recommend Jekyll, a static site generator with built-in support for GitHub Pages and a simplified build process. [[ref]](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages#static-site-generators)

I can't remember if I heard of [GitHub Pages](https://pages.github.com) or [Jekyll](https://jekyllrb.com) (or maybe [Octopress](http://octopress.org)?) first, but a ruby-based static site generator with free build & hosting is totally sufficient for me, especially when it's combined with GitHub's authn/authz and git's version control. I don't really need GitHub's [2FA](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication#configuring-two-factor-authentication-using-a-security-key) protecting this content, but I almost cannot imagine creating content without version control and `git` is the one I know the best at this point.

## [<i class="fas fa-fw fa-vial" aria-hidden="true"></i> Jekyll](https://jekyllrb.com)

[Jekyll](https://jekyllrb.com) provides the underlying static site generator, turning posts written in (mostly) markdown into the blog content. I benefit from a variety of [plugins that GitHub Pages supports](https://pages.github.com/versions/), but can't add additional ones.

However, bare Jekyll would require a lot of additional work: creating the site structure, navigation, `<head>` content, stylesheets, etc. That's where the Jekyll theme comes in.

## [<i class="fas fa-fw fa-pencil-alt" aria-hidden="true"></i> Minimal Mistakes theme](https://mmistakes.github.io/minimal-mistakes/)

> A flexible two-column Jekyll theme. Perfect for building personal sites, blogs, and portfolios.

I chose [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/) for my theme. It has many [configuration options](https://mmistakes.github.io/minimal-mistakes/docs/configuration/), allowing pieces of functionality to be turned on/off and otherwise customized. ex: set up author profiles with various social media links, or choose between several ways of adding reader comments to pages. All that's required is to edit the [default `_config.yml`](https://github.com/mmistakes/minimal-mistakes/blob/4.24.0/_config.yml)

Another customization option is to [override specific pieces](https://mmistakes.github.io/minimal-mistakes/docs/overriding-theme-defaults/) of the theme code: some that are "supported" and others that require manual changes when I update to a newer version of the theme.

An example of a "supported" extension point is a [custom analytics provider](https://mmistakes.github.io/minimal-mistakes/docs/configuration/#analytics), which requires a `_config.yml` setting *and* putting the necessary code into `_includes/analytics-providers/custom.html` (which is blank in the theme's files and automatically included in the right place via the config setting).

The "unsupported" version is to simply copy a theme file into the blog's repository, and make any/all changes desired. The local copy takes priority over the theme's file. Unfortunately, it requires manually reconciling my changes with any changes in the theme when upgrading to a new version of the theme. I've done this with a couple of files, like `_includes/scripts.html` to change the order of other includes.

As a result of these features and customization options, it feels like I spend more time working with the theme's documentation and code than I do with Jekyll. The theme is also 100% responsible for the look & feel of the site.

## <i class="fas fa-fw fa-globe" aria-hidden="true"></i> Custom Domain

I honestly don't remember any details of setting up my custom domain. GitHub has [documentation](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages) on the process, which I'm sure I'd follow if I had to set it up again.

I'm using [Cloudflare](https://www.cloudflare.com) for DNS on my domain and as a CDN for the blog. I started with Cloudflare for [dynamic dns]({% post_url 2017-02-22-dnsmasq-is-my-favorite-router-feature %}), and as far as I remember there wasn't any reason not to keep using it when I set up the blog. I believe Cloudflare has a setting that forces https that's enabled for the blog.

# <i class="fas fa-fw fa-ship" aria-hidden="true"></i> Shipping New Content

GitHub Pages makes this easy. I simply `git push` to the remote, and GitHub builds and deploys a new version of the site. It's been a while since I've encountered an error building, but [logs are available for troubleshooting](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-jekyll-build-errors-for-github-pages-sites) and it's usually very fast.

It's so easy that I've gotten into the habit of simply writing/editing posts on my iPad and pushing them live directly. Once they build, I can fix any typos or other mistakes and redeploy.

## iOS: <i class="fas fa-fw fa-fingerprint" aria-hidden="true"></i> Working Copy and <i class="fas fa-fw fa-asterisk" aria-hidden="true"></i> Editorial

I don't spend much time sitting in front of a computer during my personal time. I'm far more likely to use my iPad Pro. For the blog, I mostly rely on two apps.

[Working Copy](https://apps.apple.com/us/app/working-copy-git-client/id896694807?itsct=apps_box_link&itscg=30200) is a fantastic git client for iOS that I highly recommend. I'm not doing anything hard with the blog, being able to pull the latest code, make changes, and push is sufficient.

Working Copy introduced me to [Editorial](https://apps.apple.com/us/app/editorial/id673907758?itsct=apps_box_link&itscg=30200) via the [instructions for editing in another app](https://workingcopyapp.com/manual/edit-in-app). Editorial also comes with glowing reviews on [MacStories](https://www.macstories.net/tag/editorial/). I set up some basic automation to interoperate with Working Copy, and a [workflow to create a new post](editorial://add-workflow?workflow-data-b64=eNrtV21v0zAQ_ivGEhpISdV1Y4N8qUYZ2tBeqq5iQuuE3PjaRnXsEDsrJcp_5-wk3apuUIY0GKyRovR899zdc-fknNMoVJIGtP-pe9g5PTnz946OPp_3Dvv7jUSOqUdZaCIlNQ0ucpqwTMNbGKkUepmUESoEIyY0eOXSeWQmKjNnEzXDtS5LWQwGUr3QCjNtVNyPjAD0ieihYBqX6blKpyOhZnvOWw--ZKBNH76aQ5lkhlr8a7Ccxpkw0VEk4TSx-jRoetSgtl0z88SCM37FZAjcgqC9UVOQPSbHYAGKWp1S-1jF01XakDK4ct05L104tywzqqPSFFyU-5INBXAamDTD3KYwHyqW8sbWIl2nz5LIMBF9Yz-yaS1sdAJCdCYQTpHCu9R3F-q1qO-ybhZF4T1cnc4MevjI0shGuVIkic9okiCrvqlYvWIig3WrRPOmRzYLVCu74LpqbfqwiXYmNqYO06tZhiisu3DzQYN6H0neg0SwcDWqtJLfaz-MEPjXLdu16WJP_s9sPHti44al98TGDcvgH2TDvz8d5M_SsdZHbBQJeOwfsZ9OVfUcZNhYe-T6Tn9nuFod1f6-6lZJPtbhJAVm4ARm71SYxSBXC4sjvrHytVPb2qlye84ROjg-Rp18u7kkPDhwwu0lobY85q-2KmFFbN6q8ZaGwXz3TW0cZqlWqZVtLQPO8efEr5fEnDvnrSVhHDvQnTvq4vv-QAo2R84DopFyAQPpYglIeyAdBGn7eJF2gBcuYvgBuWhfDhBqKCI9AR4QO4sPpENDHbyV7y8BZTety3HrNopvSbJOZ-kVlDdXWbrRgb67GjG3QpWALE8QRXHp1T2P_UI-wHQuBLHnHsTkoMM0qnYpLbtKE0aGgskpsZUjM2zZ2moCjGN_kUgSMwES23U8GWGfiTmxPoGTkRKo0yDdVMWJ0fg_JS4FwiR37xbywh6SYjwchUygIeNck42hUOMNwqx3VHrZoMV3eYIX8w~~) with some basic [front matter](https://jekyllrb.com/docs/front-matter/) and an (approximately) correctly formatted filename. 

🤞 that both of these apps continue to be maintained. Editorial doesn't look like it's changing much, so I continue to be afraid it'll stop working sooner or later, but so far so good.

## <i class="fas fa-fw fa-tools" aria-hidden="true"></i> macOS Jekyll Build

Ahhh, here's my opportunity to overcomplicate things! I blame most of the complication on an old project called [Pow](https://web.archive.org/web/20210622195420/http://pow.cx/manual.html), which has been replaced by `puma-dev`

### [<i class="fas fa-fw fa-cat" aria-hidden="true"></i> puma-dev](https://github.com/puma/puma-dev)

> Puma-dev is the emotional successor to pow. It provides a quick and easy way to manage apps in development.

I like [puma-dev](https://github.com/puma/puma-dev) because it combines two features: reverse proxy and local DNS. I don't know if it's best-of-breed these days, I didn't spend long looking.

#### <i class="fas fa-fw fa-exchange-alt" aria-hidden="true"></i> Reverse Proxy

puma-dev provides a reverse proxy, and it's configured by adding files to `~/.puma-dev/`, with a variety of possibilities:

- symlink to directory
    - loads `config.ru` out of that directory, and manages the associated [rack](https://github.com/rack/rack) application
    - statically serves files from `public/`, for all others
- text file
    - `port`
    - `address:port`

For local development, this is enough configuration for me. I love how simple it is. puma-dev listens on ports 80 and 443 by default, and uses a wildcard cert to provide trusted TLS connections. The file/symlink's name (ex: `blog`) is mapped to the domain (ex: `http://blog.test/`)

Notice that `rack` applications are provided with some extra features. This is because the tool comes from the ruby community, but IMO it remains useful for any local web development work I'm doing.

#### <i class="fas fa-fw fa-map-signs" aria-hidden="true"></i> DNS Resolver

The other half of the magic is providing a DNS resolver for the chosen top level domain (ex: `test`), mapping lookups to `127.0.0.1`. Pow ran into trouble because it was using `dev` and then Google purchased that TLD! So we've all learned our lesson and the default is now `.test` - one of the 4 reserved TLDs - but good luck getting everyone to conform and so it's configurable.

I continue to be amazed at how easy this is to setup: just drop `/etc/resolver/test` onto disk with the `nameserver` and `port` ([man page](https://web.archive.org/web/20150923013656/https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/resolver.5.html))

#### <i class="fas fa-fw fa-key" aria-hidden="true"></i> launchd.plist 

`puma-dev` listens on all interfaces when it installs itself. I've manually changed my install to only listen to the localhost interface, and [filed a feature request](https://github.com/puma/puma-dev/issues/306) with the project. This prevents other machines accessing my WIP development code (which for the entirely static blog would not be particularly worrisome), and makes me feel better about having it running all the time.

#### <i class="fas fa-fw fa-undo" aria-hidden="true"></i> App management

Since `puma-dev` manages the app lifecycle, I need a way to control it. My most common operation is to `touch tmp/restart` in the blog's directory, which causes `puma-dev` to shutdown the app. It's started up on the next request, and that makes it easy to pick up `_config.yml` changes.

### [<i class="fas fa-fw fa-server" aria-hidden="true"></i> rack-jekyll](https://github.com/adaoraul/rack-jekyll)

> Transform your Jekyll app into a Rack application.

I use [rack-jekyll](https://github.com/adaoraul/rack-jekyll) for automatic generation of the static site files. Since `puma-dev` (and `pow` before it) knows how to launch / shutdown `rack` applications, it becomes a pretty easy workflow to edit files, load them in the browser, and then know the process will stop running soon after I'm done.

I've been living with a warning from GitHub that my repo has an insecure version of `rack`, because the gem hasn't been released in a long time, but using the latest version via git fixes that.

I also ran into some _weird_ behaviors when running through `puma-dev` that were solved by requiring `github-pages` in my `config.ru`. It loads a variety of plugins, changes some configuration settings, and basically ensures I'm building similarly to the way GitHub Pages will when I push the code.

I've been poking at the jekyll config passed into the rack app, turning up the logging and showing any/all unpublished/incomplete posts. I don't yet know if it's better to see what's in progress, or better to have a live preview of production. Maybe that's something I change as needed.

### [<i class="fas fa-fw fa-edit" aria-hidden="true"></i> jekyll-compose](https://github.com/jekyll/jekyll-compose)

[jekyll-compose](https://github.com/jekyll/jekyll-compose) provides some basic `jekyll` command line additions that make it easy to create drafts & posts with specific front matter, and correct names. I definitely forget that this exists, and end up either creating posts through my workflow on Editorial or copying from an existing file.

However, if I remember or if I re-read this post, `bundle exec jekyll {post,draft} "[title]"` seems like a better way to go about it. The `publish`, `unpublish`, and `rename` commands look good too.

# <i class="fas fa-fw fa-download" aria-hidden="true"></i> Installing

How I would probably reinstall this on a mac

0. Install & setup `git`
1. Figure out ruby & versioning. I'm currently trying [asdf](http://asdf-vm.com), and its [Getting Started Guide](http://asdf-vm.com/guide/getting-started.html) looks good. I don't think the specific ruby version matters much, I'm using some arbitrary new, stable version.
2. `bundle install` from blog's repo to install the necessary gems.
3. Install [puma-dev](https://github.com/puma/puma-dev) following their instructions. Ensure `~/Library/LaunchAgents/io.puma.dev.plist` is binding to `127.0.0.1` instead of `0.0.0.0`
4. `puma-dev link -n "blog" [path]` to add the symlink for puma-dev

----

### Postscript
{: .no_toc }

Well, I've written what I wanted: a tour of the various moving pieces and why each one is important to me. I think this is what I'll find valuable in the future, but now I have questions:

- Why isn't this simply in the README.md of the blog?
- Will I update this post, or write follow ups as this changes?
- Is this the level of documentation that I'd want to represent me to future potential employers?
- Other than hypothetical future me, who would get any value from reading this?

🤷‍♂️