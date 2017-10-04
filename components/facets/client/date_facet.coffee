@selected_timestamp_tags = new ReactiveArray []

Template.timestamp_facet.onCreated ->
    @autorun => 
        Meteor.subscribe('timestamp_tags', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            # author_id=@data.author_id
            )


Template.timestamp_facet.helpers
    timestamp_tags: ->
        doc_count = Docs.find(type:'journal').count()
        # if selected_timestamp_tags.array().length
        if 0 < doc_count < 3
            Timestamp_tags.find { 
                count: $lt: doc_count
                }, limit:20
        else
            Timestamp_tags.find({}, limit:20)
            
            
    timestamp_tag_class: ->
        button_class = []
        switch
            when @index <= 5 then button_class.push 'large '
            when @index <= 10 then button_class.push ' '
            when @index <= 15 then button_class.push 'small '
            when @index <= 20 then button_class.push ' tiny'
        return button_class

    selected_timestamp_tags: -> selected_timestamp_tags.array()
    # selected_author_ids: -> selected_author_ids.array()



Template.timestamp_facet.events
    'click .select_timestamp_tag': -> selected_timestamp_tags.push @name
    'click .unselect_timestamp_tag': -> selected_timestamp_tags.remove @valueOf()
    'click #clear_timestamp_tags': -> selected_timestamp_tags.clear()



    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_timestamp_tags.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_timestamp_tags.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_timestamp_tags.pop()
                    
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        selected_timestamp_tags.push doc.name
        $('#search').val ''
