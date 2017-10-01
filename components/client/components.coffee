Template.resonate_button.helpers
    resonate_button_class: -> 
        if Meteor.userId()
            if @favoriters and Meteor.userId() in @favoriters then 'teal' else 'basic'
        else 'grey disabled'

Template.resonate_button.events
    'click .resonate_button': (e,t)-> 
        if Meteor.userId() 
            Meteor.call 'favorite', Template.parentData(0)
            $(e.currentTarget).closest('.resonate_button').transition('pulse')
        else FlowRouter.go '/sign-in'


Template.resonates_list.helpers
    resonates_with_people: ->
        if @favoriters
            if @favoriters.length > 0
        # console.log @favoriters
                Meteor.users.find _id: $in: @favoriters
    
    
Template.read_by.onCreated ->
    @autorun => Meteor.subscribe 'read_by', FlowRouter.getParam('doc_id')
    
Template.read_by.helpers
    read_by: ->
        if @read_by
            if @read_by.length > 0
        # console.log @read_by
                Meteor.users.find _id: $in: @read_by
    
Template.toggle_doc_read.events
    'click .mark_read': (e,t)-> 
        Meteor.call 'mark_read', @_id
        
    'click .mark_unread': (e,t)-> Meteor.call 'mark_unread', @_id

Template.toggle_doc_read.helpers
    read: -> @read_by and Meteor.userId() in @read_by
    
    

    
    
Template.doc_matches.onCreated ->
    @is_calculating = new ReactiveVar 'false'
    
Template.doc_matches.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500
    
Template.doc_match.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500
    
Template.doc_matches.helpers
    # calculate_button_class: ->
        # if Template.instance().is_calculating then 'loading' else ''
    
Template.doc_matches.events
    'click #compute_doc_matches': ->
        $( "#compute_doc_matches" ).toggleClass( "loading" )
        # console.log @
        Meteor.call 'find_top_doc_matches', @_id, (err, res)->
            $( "#compute_doc_matches" ).toggleClass( "loading" )
            $( ".title" ).addClass( "active" )
            $( ".match_content" ).addClass( "active" )
            # console.log res
            
            
Template.doc_match.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data.doc_id
            
Template.doc_match.helpers
    match_doc: -> Docs.findOne @doc_id
            
            
            
Template.request_tori_feedback.onCreated ->
    @autorun => Meteor.subscribe 'feedback_requested', @data._id
            
            
Template.request_tori_feedback.helpers
    feedback_requested: ->
        Docs.findOne
            type: 'transaction'
            parent_id: 'AHQnLo2eDES57mzJD'
            author_id: Meteor.userId()
            object_id: @_id


Template.request_tori_feedback.events
    'click #request_feedback': ->
        # console.log @
        Meteor.call 'create_transaction', 'AHQnLo2eDES57mzJD', @_id, ->
            Bert.alert "Transaction with Thoughtful Feedback created.", 'success', 'growl-top-right'

        
    'click #cancel_request': ->
        # console.log @
        request_transaction = Docs.findOne
            type: 'transaction'
            parent_id: 'AHQnLo2eDES57mzJD'
            author_id: Meteor.userId()
            object_id: @_id
        Docs.remove request_transaction._id, ->
            Bert.alert "Transaction with Thoughtful Feedback canceled.", 'info', 'growl-top-right'
        
       
       
        
        
Template.parent_doc_segment.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500
    
    
    
    
    
Template.view_published_toggle.helpers
    viewing_mine: -> Session.equals 'view_private',true  
    viewing_all: -> Session.equals 'view_private',false  


Template.view_published_toggle.events
    'click #view_my_entries': (e,t)-> Session.set('view_private',true)    
    'click #view_all_entries': (e,t)-> Session.set('view_private', false)    


Template.view_read_toggle.helpers
    viewing_unread: -> Session.equals 'view_unread', true  
    viewing_all: -> Session.equals 'view_unread',false  


Template.view_read_toggle.events
    'click #view_unread': (e,t)-> Session.set('view_unread', true)    
    'click #view_all': (e,t)-> Session.set('view_unread', false)    



# Template.instance().stripe = Stripe.configure(
#     key: stripe_key
#     image: '/toriwebster-logomark-04.png'
#     locale: 'auto'
#     # zipCode: true
#     token: (token) ->
#         # console.log token
#         purchasing_item = Docs.findOne Session.get 'purchasing_item'
#         console.dir 'purchasing_item', purchasing_item
#         charge = 
#             amount: purchasing_item.price*100
#             currency: 'usd'
#             source: token.id
#             description: token.description
#             receipt_email: token.email
#         Meteor.call 'processPayment', charge, (error, response) =>
#             if error then Bert.alert error.reason, 'danger'
#             else
#                 Meteor.call 'register_transaction', purchasing_item._id, (err, response)->
#                     if err then console.error err
#                     else
#                         Bert.alert "You have purchased #{purchasing_item.title}.", 'success'
#                         Docs.remove Session.get('current_cart_item')
#                         FlowRouter.go "/account"
#     # closed: ->
#     #     Bert.alert "Payment Canceled", 'info', 'growl-top-right'
# )