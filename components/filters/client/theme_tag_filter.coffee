@selected_theme_tags = new ReactiveArray []

Template.theme_tag_filter.onCreated ->
    @autorun => 
        Meteor.subscribe('theme_tags', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            type=@data.type
            author_id=@data.author_id
            )

Template.theme_tag_filter.helpers
    theme_tags: ->
        doc_count = Docs.find(type:'journal').count()
        # if selected_theme_tags.array().length
        if 0 < doc_count < 3
            Tags.find { 
                count: $lt: doc_count
                }, limit:10
        else
            Tags.find({}, limit:10)
            
            
    cloud_tag_class: ->
        button_class = []
        switch
            when @index <= 5 then button_class.push 'large '
            when @index <= 10 then button_class.push ' '
            when @index <= 15 then button_class.push 'small '
            when @index <= 20 then button_class.push ' tiny'
        return button_class

    selected_theme_tags: -> selected_theme_tags.array()
    # selected_author_ids: -> selected_author_ids.array()
    settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Tags
                field: 'name'
                matchAll: false
                template: Template.tag_result
            }
            ]
    }



Template.theme_tag_filter.events
    'click .select_theme_tag': -> selected_theme_tags.push @name
    'click .unselect_theme_tag': -> selected_theme_tags.remove @valueOf()
    'click #clear_theme_tags': -> selected_theme_tags.clear()



    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_theme_tags.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_theme_tags.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_theme_tags.pop()
                    
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        selected_theme_tags.push doc.name
        $('#search').val ''
