module ApplicationHelper

def star_counter(post)
  stars = post.stars.find_by(user: current_user)

  star_count = stars.nil? ? 0 : stars.star_count

  method = (
  if stars.nil?
    :post
  else
    :patch
  end
  )

  empty_star = star_count +1

  links_array = []

  1.upto(star_count) do |s|
    if stars.nil?
      path =  (link_to fa_icon("star"), post_stars_path(post, star:{star_count: s}), method: method)
    else
      path =  (link_to fa_icon("star"), post_star_path(post, stars, star:{star_count: s}), method: method)
    end
    links_array << path
  end

  empty_star.upto(5) do |s|
    if stars.nil?
      path =  (link_to fa_icon("star-o"), post_stars_path(post, star:{star_count: s}), method: method)
    else
      path =  (link_to fa_icon("star-o"), post_star_path(post, stars, star:{star_count: s}), method: method)
    end
    links_array << path
  end

  safe_join(links_array, '')

  end

  def star_average(post)
    stars = post.stars
    star_array = []
    stars.each do |s|
      star_array << s.star_count
    end
    return (star_array.reduce(:+)) / (star_array.size.to_f)
  end
end
