module Jekyll

  # Extensions to the Jekyll Page and Post class.
  # We want to add previous and next links according to category
  
  class Post
    
    # Attributes for Liquid templates
    NEW_ATTRIBUTES_FOR_LIQUID = %w[
      title
      url
      date
      id
      categories
      next
      previous
      category_previous
      category_next
      tags
      content
      excerpt
      path
    ]

    attr_accessor :posttype

    alias old_initialize initialize
    def initialize(site, source, dir, name)

      @site = site
      @dir = dir
      @base = self.containing_dir(source, dir)
      @name = name

      self.categories = dir.downcase.split('/').reject { |x| x.empty? }
      self.process(name)
      self.read_yaml(@base, name)

      if self.data.has_key?('date')
        self.date = Time.parse(self.data["date"].to_s)
      end

      self.published = self.published?

      self.populate_categories
      self.populate_tags
      
      # Added a posttype category
      if self.data.has_key?('posttype') 
        self.posttype = self.data['posttype']
      else
        if dir == "papers"
          self.posttype = "publication"
        else
          self.posttype = dir
        end
      end
    end
    


    alias orig_to_liquid to_liquid
    def to_liquid
      further_data = Hash[NEW_ATTRIBUTES_FOR_LIQUID.map { |attribute|
                            [attribute, send(attribute)]
                          }]
      data.deep_merge(further_data)
    end
#    def to_liquid
#      h = orig_to_liquid
#      h['category_previous'] = category_previous
#      h['category_next'] = category_next
#      h
#    end

    def category_previous
      pos = self.site.posts.index(self)
      flag = 0
      k = pos 
      ptype = self.site.posts[pos].posttype
      if ptype != "publication"
        while ( k > 0 && flag == 0 ) do
          if self.site.posts[k-1].posttype == ptype
            ret = self.site.posts[k-1]
            flag = 1
          end
          k = k - 1
        end
        if flag == 1
          ret
        else
          nil 
        end
      end
    end

    def category_next
      pos = self.site.posts.index(self)
      flag = 0
      k = pos 
      ptype = self.site.posts[pos].posttype
      if ptype != "publication"
        while ( k <  self.site.posts.length-1 && flag == 0 ) do
          if self.site.posts[k+1].posttype == ptype
            ret = self.site.posts[k+1]
            flag = 1
          end
          k = k + 1
        end
        if flag == 1
          ret
        else
          nil 
        end
      end
    end
    
  end
end
