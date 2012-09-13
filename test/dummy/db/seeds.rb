Plan.create([{id: 1,name: 'Friends and Family',description: 'Unlimited private plan for friends of Schedulised',max_users: 0,max_groups: 0,max_events: 0,max_active_events: 0,max_event_days: 0,price: 0,private: true}]) if !Plan.exists?(1)
Role.create([{id: 1,name: 'trainee'},{id: 2,name: 'trainer'},{id: 3,name: 'group_admin'},{id: 4,name: 'account_admin'},{id: 5,name: 'god'}]) if Role.count == 0

if ProfileField.count == 0 
  profile_fields = ProfileField.create([{id: 1,name:'twitter_handle',var_type: 'string',input_type: 'text_field'},{id: 2,name:'email',var_type: 'string',input_type: 'text_field'},{id: 3,name:'bio',var_type: 'text',input_type: 'text_area'},{id: 4,name:'url',var_type: 'string',input_type: 'text_field'},{id: 5,name:'phone',var_type: 'string',input_type: 'text_field'},{id: 6,name:'company',var_type: 'string',input_type: 'text_field'},{id: 7,name:'company_url',var_type: 'string',input_type: 'text_field'}])
  
  user_profile_fields = ProfileableProfileField.create([{profile_field_id: 1,profileable_type: 'User',publik: true,required: false},
                                                            {profile_field_id: 2,profileable_type: 'User',publik: true,required: true},
                                                              {profile_field_id: 3,profileable_type: 'User',publik: true,required: false},
                                                                {profile_field_id: 4,profileable_type: 'User',publik: true,required: false},
                                                                  {profile_field_id: 5,profileable_type: 'User',publik: false,required: false}])
end

