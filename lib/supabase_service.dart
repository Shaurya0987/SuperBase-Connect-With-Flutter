import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient supabase=Supabase.instance.client;

  //  Create -> Insert in Database
  Future<dynamic>createStudent(String name,int age)async{
    try {
      final response= await supabase
        .from('students')
        .insert({
          'name':name,
          'age' :age
        })
         .select();

      return response;
    } catch (error) {
      throw Exception("Insert Error: $error");
    }
  }

  //  Read data from Database
  Future<List<dynamic>>getStudents() async{
    try {
      final response=await supabase
        .from('students')
          .select('*')
          .order('created_at',ascending: false);

      return response;
    } catch (error) {
      throw Exception("Select Error: $error");
    }
  }

  //  Update data in Column
  Future<dynamic> updateStudent(String id, String name, int age) async {
    try {
      final response = await supabase
          .from('students')
          .update({
            'name': name,
            'age': age,
          })
          .eq('id', id)
          .select();

      return response;
    } catch (error) {
      throw Exception("Update Error: $error");
    }
  }

  //  Delete 
  Future<dynamic> deleteStudent(String id) async{
    try {
      final response=await supabase
        .from('students')
        .delete()
        .eq('id',id);

      return response;
    } catch (error) {
      throw Exception("Delete Error $error");
    }
  }


}

/*          Extra Features to solect Queries  
                      Also Add Some Conditions          =>  "Filters"  <=

          .eq('age':20);   -> Select where age is 20
          .neq('age':20);   -> Select where age is not 20
          .gt('age':20);   ->age is greater than 20
          .gte('age':20);   ->age is greater than and equal to 20
          .lt('age':20);   ->age is less than 20
          .lte('age':20);   ->age is less than and equal to 20
          .like('name','S%');  ->where names Starts with S
          .like('name','%a');  ->where names ends with A
          .like('name','%and%');  ->where names contains "and"
          .ilike('name','%Sherry%');  ->Case inSenstive =where names contains "sherry" "SHERRY" anything
          .in('age',[18,19,20]);  ->student aged 18 19 20
          .not('age','gt',20);   ->ages not greater than 20
          .is_('age',null);  ->Null check
          .order('created_at',ascending:false);   -> Newest First
          .limit(5)  ->only first 5 students
          .range(0,9)  ->return rows from index 0 to index 9  => total 10 rows
        */



/*           More Important Features of Learn

🔥 5️⃣ AUTHENTICATION (VERY IMPORTANT)
1. upabase gives built-in login system.

Operations:

✔ signUp()
✔ signIn()
✔ signOut()
✔ getUser()
✔ resetPassword()
✔ OAuth (Google, GitHub, etc.)

🔥 6️⃣ STORAGE OPERATIONS (Files & Images)

await supabase.storage
    .from('avatars')
    .upload('file.png', file);

Used for:

Profile images

Documents

Chat app media

Product images

🔥 7️⃣ REALTIME OPERATIONS (Live updates)

Supabase.instance.client
  .channel('students')
  .onPostgresChanges(
    event: PostgresChangeEvent.insert,
    table: 'students',
    callback: (payload) {
      print(payload);
    },
  )
  .subscribe();

Used for:

Chat apps

Notifications

Live dashboards

Multi-user apps

🔥 8️⃣ SECURITY OPERATIONS (RLS Policies)

RLS controls:

Who can insert

Who can read

Who can update

Who can delete

🔥 9️⃣ REMOTE SQL (Advanced)

final data = await supabase.rpc('your_function_name', params);

Used for:

Complex joins

Analytics

Stored procedures

Heavy calculations

🔥 10️⃣ RELATIONS (Joins)

Supabase supports joining relational tables.

Example:

Students + marks: