if Meteor.isClient
    FlowRouter.route '/stats', action: (params) ->
        BlazeLayout.render 'layout',
            main: 'stats'
    
    
    
    Template.stats.onCreated ->
        @autorun => Meteor.subscribe('my_stats', selected_theme_tags.array(), selected_upvoter_ids.array())

        
    # Template.stats.onRendered ->
    #     Meteor.setTimeout ->
    #         $('.ui.accordion').accordion()
    #     , 500

    Template.stats.helpers
        upvoted_docs: -> 
            Docs.find
                author_id: Meteor.userId()
                points: $gt: 0

        upvoter_users: ->
            users = []
            
            for upvoter_id in @upvoters
                # console.log Meteor.users.findOne upvoter_id
                users.push Meteor.users.findOne upvoter_id
            users
            
    # Template.bookmark.helpers
    #     tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

            
            
    Template.stats.events
        'change #share_stats': (e,t)->
            value = $('#share_stats').is(":checked")
            Meteor.users.update Meteor.userId(), 
                $set:
                    "profile.share_stats": value
    

        'click .select_tag': -> selected_theme_tags.push @name
        'click .unselect_tag': -> selected_theme_tags.remove @valueOf()
        'click #clear_tags': -> selected_theme_tags.clear()

    
            
if Meteor.isServer
    publishComposite 'my_stats', (selected_theme_tags=[], selected_upvoter_ids)->
        {
            find: ->
                match = {}
                
                if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
                if selected_upvoter_ids.length > 0 then match.upvoters = $all: selected_upvoter_ids
                match.points = $gt: 0
                match.author_id = Meteor.userId()
                Docs.find match,
                    limit: 10
                    sort: points: -1
            children: [
                { find: (doc) ->
                    # console.log 'stats doc', doc
                    Meteor.users.find 
                        _id: $in: doc.upvoters
                    }
                ]    
        }


    Meteor.publish 'stats_tags', (selected_theme_tags, selected_upvoter_ids)->
        
        self = @
        match = {}
        
        if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
        if selected_upvoter_ids.length > 0 then match.author_id = $in: selected_upvoter_ids
        match.points = $gt: 0
        match.author_id = Meteor.userId()
        # console.log match
        
        cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_theme_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
            