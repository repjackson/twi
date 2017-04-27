Template.voting.helpers
    vote_up_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @upvoters and Meteor.userId() in @upvoters then 'green'
        else 'outline'

    vote_down_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @downvoters and Meteor.userId() in @downvoters then 'red'
        else 'outline'

Template.voting.events
    'click .vote_up': -> 
        if Meteor.userId() then Meteor.call 'vote_up', @_id
        else FlowRouter.go '/sign-in'

    'click .vote_down': -> 
        if Meteor.userId() then Meteor.call 'vote_down', @_id
        else FlowRouter.go '/sign-in'


Template.big_both_voter.helpers
    vote_up_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @upvoters and Meteor.userId() in @upvoters then 'green'
        else 'outline'

    vote_down_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @downvoters and Meteor.userId() in @downvoters then 'red'
        else 'outline'

Template.big_both_voter.events
    'click .vote_up': -> 
        if Meteor.userId() then Meteor.call 'vote_up', @_id
        else FlowRouter.go '/sign-in'

    'click .vote_down': -> 
        if Meteor.userId() then Meteor.call 'vote_down', @_id
        else FlowRouter.go '/sign-in'



Template.toggle_friend.helpers
    is_friend: -> if Meteor.user()?.friends then @_id in Meteor.user().friends
        
Template.toggle_friend.events
    'click #add_friend': -> Meteor.users.update Meteor.userId(), $addToSet: friends: @_id
    'click #remove_friend': -> Meteor.users.update Meteor.userId(), $pull: friends: @_id


Template.published.events
    'click #publish': -> Docs.update @_id, $set: published: true
    'click #unpublish': -> Docs.update @_id, $set: published: false


Template.edit_button.events
    'click .edit_this': -> Session.set 'editing_id', @_id
    'click .save_doc': -> Session.set 'editing_id', null

Template.edit_link.events
    'click .edit_this': -> Session.set 'editing_id', @_id
    'click .save_doc': -> Session.set 'editing_id', null


Template.rating.onRendered ->
    # console.log 'template data', @data
    self = @
    
    @autorun =>
        if @subscriptionsReady()
            session_id = FlowRouter.getParam('session_id')
            existing_rating =         
                Docs.findOne
                    parent_id: self.data._id
                    type: 'rating'
                    session_id: session_id
            # console.log 'existing rating', existing_rating
            if existing_rating then initial_rating = existing_rating.rating
            else initial_rating = 0
            # console.log initial_rating
            Meteor.setTimeout ->
                $('.ui.rating').rating
                    # initialRating: initial_rating,
                    maxRating: 5
                    # onRate: (value)->
                    #     console.log value
            , 2000
            # console.log 'subs ready'

    
Template.rating.helpers
    rating_doc: ->
        session_id = FlowRouter.getParam('session_id')
        rating_doc = 
            Docs.findOne
                parent_id: @_id
                type: 'rating'
                session_id: session_id
                author_id: Meteor.userId()
        rating_doc
            
Template.rank.helpers
    rank_doc: ->
        rank_doc = 
            Docs.findOne
                parent_id: @_id
                type: 'rank'
                author_id: Meteor.userId()
        rank_doc
            
    button_class: ->
        

Template.rank.events
    'click #increase_index': ->
        rank_doc = 
            Docs.findOne
                parent_id: @_id
                type: 'rank'
                author_id: Meteor.userId()
                group: 'personality_colors'
        if rank_doc
            Docs.update rank_doc._id, 
                $inc: number: 1
            one_up = rank_doc.number + 1
            existing_rank_doc = 
                Docs.findOne
                    type: 'rank'
                    author_id: Meteor.userId()
                    number: one_up
                    group: 'personality_colors'
            console.log existing_rank_doc
            if existing_rank_doc
                Docs.update existing_rank_doc._id,
                    $inc: number: -1
        else
            Docs.insert
                type: 'rank'
                parent_id: @_id
                number: 1
                group: 'personality_colors'



Template.rating.events
    'click .rating': (e,t)->
        session_id = FlowRouter.getParam('session_id')
        rating = $(e.currentTarget).closest('.rating').rating('get rating')
        rating_doc = 
            Docs.findOne
                parent_id: @_id
                type: 'rating'
                session_id: session_id
        if rating_doc
            new_tags = @tags
            new_tags.push 'rating'

            Docs.update rating_doc._id, 
                $set: 
                    rating: rating
                    tags: new_tags
        else
            new_tags = @tags
            new_tags.push 'rating'
            Docs.insert
                type: 'rating'
                parent_id: @_id
                tags: new_tags
                rating: rating
                session_id: session_id

Template.delete_button.events
    'click #delete': ->
        self = @
        swal {
            title: 'Delete?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            Docs.remove self._id
            if FlowRouter.getParam('doc_id') 
                FlowRouter.go "/#{self.type}"
Template.delete_link.events
    'click #delete': ->
        self = @
        swal {
            title: 'Delete?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            Docs.remove self._id


Template.favorite_button.helpers
    favorite_count: -> @favorite_count
    
    favorite_item_class: -> 
        if Meteor.userId()
            if @favoriters and Meteor.userId() in @favoriters then 'red' else 'outline'
        else 'grey disabled'
Template.favorite_button.events
    'click .favorite_item': -> 
        if Meteor.userId() then Meteor.call 'favorite', Template.parentData(0)
        else FlowRouter.go '/sign-in'


Template.featured.events
    'click #make_featured': -> Docs.update FlowRouter.getParam('doc_id'), $set: featured: true
    'click #make_unfeatured': -> Docs.update FlowRouter.getParam('doc_id'), $set: featured: false


Template.add_to_cart.onCreated ->
    @autorun => Meteor.subscribe 'cart'

Template.add_to_cart.events
    'click #add_to_cart': -> 
        # Session.set 'cart_item', @_id
        # FlowRouter.go '/cart'
        if Meteor.userId() then Meteor.call 'add_to_cart', @_id, =>
            Bert.alert "#{@title} Added to Cart", 'success', 'growl-top-right'
        else FlowRouter.go '/sign-in'

    'click #remove_from_cart': ->
        Meteor.call 'remove_from_cart', @_id, =>
            Bert.alert "#{@title} Removed from Cart", 'info', 'growl-top-right'
        
Template.add_to_cart.helpers
    added: ->
        Docs.findOne 
            type: 'cart_item'
            parent_id: @_id
            author_id: Meteor.userId()