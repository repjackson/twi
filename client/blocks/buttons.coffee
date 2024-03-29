
# Template.big_both_voter.helpers
#     vote_up_button_class: ->
#         if not Meteor.userId() then 'disabled'
#         else if @upvoters and Meteor.userId() in @upvoters then 'green'
#         else 'outline'

#     vote_down_button_class: ->
#         if not Meteor.userId() then 'disabled'
#         else if @downvoters and Meteor.userId() in @downvoters then 'red'
#         else 'outline'

# Template.big_both_voter.events
#     'click .vote_up': (e,t)-> 
#         if Meteor.userId() 
#             Meteor.call 'vote_up', @_id
#             # $(e.currentTarget).closest('.vote_up').transition('pulse')
#         else FlowRouter.go '/sign-in'

#     'click .vote_down': (e,t)-> 
#         if Meteor.userId() 
#             Meteor.call 'vote_down', @_id
#             # $(e.currentTarget).closest('.vote_down').transition('pulse')
#         else FlowRouter.go '/sign-in'



# Template.toggle_friend.helpers
#     is_friend: -> if Meteor.user()?.friends then @_id in Meteor.user().friends
        
# Template.toggle_friend.events
#     'click #add_friend': (e,t)-> 
#         Meteor.users.update Meteor.userId(), $addToSet: friends: @_id
#         $(e.currentTarget).closest('#add_friend').transition('pulse')

#         Meteor.call 'add_notification', @_id, 'friended', Meteor.userId()

#     'click #remove_friend': (e,t)-> 
#         Meteor.users.update Meteor.userId(), $pull: friends: @_id
#         $(e.currentTarget).closest('#remove_friend').transition('pulse')

#         Meteor.call 'add_notification', @_id, 'unfriended', Meteor.userId()

Template.published.helpers
    published_class: -> if @published is 1 then 'blue' else 'basic'
    published_anonymously_class: -> if @published is 0 then 'blue' else 'basic'
    private_class: -> if @published is -1 then 'blue' else 'basic'
    is_published: -> @published is 1
    published_anonymously: -> @published is 0
    is_private: -> @published is -1
Template.published.events
    'click #publish': (e,t)-> 
        Docs.update @_id, $set: published: 1
    'click #unpublish': (e,t)-> 
        Docs.update @_id, $set: published: -1
    'click #publish_anonymously': ->
        Docs.update @_id, $set: published: 0
        
        
        

# Template.rating.onRendered ->
#     # console.log 'template data', @data
#     self = @
    
#     @autorun =>
#         if @subscriptionsReady()
#             session_id = FlowRouter.getParam('session_id')
#             existing_rating =         
#                 Docs.findOne
#                     parent_id: self.data._id
#                     type: 'rating'
#                     session_id: session_id
#             # console.log 'existing rating', existing_rating
#             if existing_rating then initial_rating = existing_rating.rating
#             else initial_rating = 0
#             # console.log initial_rating
#             Meteor.setTimeout ->
#                 $('.ui.rating').rating
#                     # initialRating: initial_rating,
#                     maxRating: 5
#                     # onRate: (value)->
#                     #     console.log value
#             , 2000
#             # console.log 'subs ready'
# Template.rating.helpers
#     question_rating: ->
#         session_doc = Docs.findOne FlowRouter.getParam('session_id')
#         if session_doc
#             rating = _.findWhere(session_doc.ratings, {question_id: @_id})?.rating
#             rating
# Template.rank.helpers
#     rank_doc: ->
#         rank_doc = 
#             Docs.findOne
#                 parent_id: @_id
#                 type: 'rank'
#                 author_id: Meteor.userId()
#         rank_doc
            
#     button_class: ->
        

# Template.rank.events
#     'click #increase_index': ->
#         rank_doc = 
#             Docs.findOne
#                 parent_id: @_id
#                 type: 'rank'
#                 author_id: Meteor.userId()
#                 group: 'personality_colors'
#         if rank_doc
#             Docs.update rank_doc._id, 
#                 $inc: number: 1
#             one_up = rank_doc.number + 1
#             existing_rank_doc = 
#                 Docs.findOne
#                     type: 'rank'
#                     author_id: Meteor.userId()
#                     number: one_up
#                     group: 'personality_colors'
#             console.log existing_rank_doc
#             if existing_rank_doc
#                 Docs.update existing_rank_doc._id,
#                     $inc: number: -1
#         else
#             Docs.insert
#                 type: 'rank'
#                 parent_id: @_id
#                 number: 1
#                 group: 'personality_colors'
# Template.rating.events
#     'click .rating': (e,t)->
#         session_id = FlowRouter.getParam('session_id')
#         rating = $(e.currentTarget).closest('.rating').rating('get rating')
#         if Docs.findOne({_id: session_id, 'ratings.question_id': @_id})
#             # alert @_id, ' found'
#             # alert rating
#             Meteor.call 'update_rating', session_id, rating, @_id
#         else
#             # alert 'rating not found'
#             $(e.currentTarget).closest('.ui.card').transition('horizontal flip')
#             Meteor.setTimeout =>
#                 Docs.update {_id:session_id},
#                     $addToSet:
#                         ratings:
#                             rating: rating
#                             question_id: @_id
#                             tags: @tags
#             , 250







# doc version
# Template.rating.events
#     'click .rating': (e,t)->
#         session_id = FlowRouter.getParam('session_id')
#         rating = $(e.currentTarget).closest('.rating').rating('get rating')
#         rating_doc = 
#             Docs.findOne
#                 parent_id: @_id
#                 type: 'rating'
#                 session_id: session_id
#         if rating_doc
#             new_tags = @tags
#             new_tags.push 'rating'

#             Docs.update rating_doc._id, 
#                 $set: 
#                     rating: rating
#                     tags: new_tags
#         else
#             new_tags = @tags
#             new_tags.push 'rating'
#             Docs.insert
#                 type: 'rating'
#                 parent_id: @_id
#                 tags: new_tags
#                 rating: rating
#                 session_id: session_id
Template.delete_button.onCreated ->
    @confirming = new ReactiveVar(false)
            
Template.delete_button.helpers
    confirming: -> Template.instance().confirming.get()

Template.delete_button.events
    'click .delete': (e,t)-> t.confirming.set true

    'click .cancel': (e,t)-> t.confirming.set false
    'click .confirm': (e,t)-> 
        Docs.remove @_id
        FlowRouter.go("/view/#{@parent_id}")
            
Template.session_delete_button.onCreated ->
    @confirming = new ReactiveVar(false)
            
     
Template.session_delete_button.helpers
    confirming: -> Template.instance().confirming.get()
Template.session_delete_button.events
    'click .delete': (e,t)-> 
        # $(e.currentTarget).closest('.comment').transition('pulse')
        t.confirming.set true

    'click .cancel': (e,t)-> t.confirming.set false
    'click .confirm': (e,t)-> 
        $(e.currentTarget).closest('.comment').transition('fade right')
        $(e.currentTarget).closest('.notification_segment').transition('fade right')
        Meteor.setTimeout =>
            Docs.remove(@_id)
        , 1000



# Template.add_to_cart.onCreated ->
#     @autorun => Meteor.subscribe 'cart'

# Template.add_to_cart.events
#     'click #add_to_cart': (e,t)-> 
#         # console.log t.data.tags
#         # Session.set 'cart_item', @_id
#         # FlowRouter.go '/cart'
#         if Meteor.userId() then Meteor.call 'add_to_cart', @_id, =>
#             Bert.alert "#{@title} Added to Cart", 'success', 'growl-top-right'
#         else FlowRouter.go '/sign-in'

#     'click #remove_from_cart': ->
#         Meteor.call 'remove_from_cart', @_id, =>
#             Bert.alert "#{@title} Removed from Cart", 'info', 'growl-top-right'
        
# Template.add_to_cart.helpers
#     added: ->
#         Docs.findOne 
#             type: 'cart_item'
#             parent_id: @_id
#             author_id: Meteor.userId()
            
#     can_add: -> @point_price < Meteor.user().points        
            
            
Template.add_doc_button.events
    'click #add_doc': (e,t)->
        parent_doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log parent_doc.child_type
        # console.log t.data.button_text
        new_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
            # type: t.data.type
            type: parent_doc.child_type
            template: 'databank_item'
        FlowRouter.go("/edit/#{new_id}")

Template.add_doc_button.helpers
    add_button_text: -> Template.currentData().button_text
    
    
    
# Template.subscribe_button.helpers
#     subscribe_buton_class: -> if @subscribed_ids and Meteor.userId() in @subscribed_ids then 'blue' else 'basic'
#     subscribed: -> if @subscribed_ids and Meteor.userId() in @subscribed_ids then true else false
#     is_participant: -> Meteor.userId() in @participant_ids
        
# Template.subscribe_button.events
#     'click #subscribe_button': (e,t)->
#         if Meteor.userId()
#             Meteor.call 'subscribe', Template.parentData(0)
#             # $(e.currentTarget).closest('.subscribe_button').transition('pulse')
#         else FlowRouter.go '/sign-in'

#         # if Template.parentData(0).subscribers
#         #     if Meteor.userId() in Template.parentData(0).subscribers
#         #         Docs.update Template.parentData(0)._id,
#         #             $pull: subscribers: Meteor.userId()
#         #     else
#         #         Docs.update Template.parentData(0)._id,
#         #             $addToSet: subscribers: Meteor.userId()
#         #     $(e.currentTarget).closest('#subscribe_button').transition('pulse')
#         # else
#         #     Docs.update Template.parentData(0)._id,
#         #         $set: subscribers: []
                
                
                
#         # 'click .bookmark_button': (e,t)-> 
#         # if Meteor.userId() 
#         #     Meteor.call 'bookmark', Template.parentData(0)
#         #     # $(e.currentTarget).closest('.bookmark_button').transition('pulse')
#         # else FlowRouter.go '/sign-in'
            
            
# Template.toggle_zen_mode_button.helpers
#     zen_mode: -> Session.get 'zen_mode'
    
# Template.toggle_zen_mode_button.events
#     'click #turn_off_zen_mode': (e,t)-> 
#         Session.set 'zen_mode', false
#         # $(e.currentTarget).find('#nav_menu').transition('fade right')
#     'click #turn_on_zen_mode': (e,t)-> 
#         # $(e.currentTarget).find('#nav_menu').transition('fade left')
#         Session.set 'zen_mode', true
    
    
    
# Template.join_button.helpers
#     joined: ->
#         if Meteor.userId() in @participants then true else false

# Template.join_button.events
#     'click #join': ->
#         Docs.update @_id,
#             $addToSet: participants: Meteor.userId()
            
#     'click #leave': ->
#         Docs.update @_id,
#             $pull: participants: Meteor.userId()




Template.toggle_view_mode_button.helpers
    viewing_public: -> Session.equals 'view_private', false

Template.toggle_view_mode_button.events
    'click #toggle_view_mode': ->
        if Session.equals 'view_private', true
            Session.set 'view_private', false
        else
            Session.set 'view_private', true
            
# Template.toggle_completed_button.events
#     'click #toggle_view_mode': ->
#         if Session.equals 'view_private', true
#             Session.set 'view_private', false
#         else
#             Session.set 'view_private', true
            
Template.session_edit_button.events
    'click .toggle_editing': ->
        if Session.equals 'editing_id', @_id
            Session.set 'editing_id', null
        else
            Session.set 'editing_id', @_id
            
    
Template.admin_toggle.events
    'click #toggle_admin_mode': ->
        current_mode = Session.get 'admin_mode'
        Session.set 'admin_mode', !current_mode
    
    