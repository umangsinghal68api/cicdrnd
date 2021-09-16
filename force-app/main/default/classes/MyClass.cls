public class MyClass 
{
	public void fun()
    {
        list<String> fruit = new list<string>();
        fruit.add('Apple');
        fruit.add('Mango');
        fruit.add('Pine Apple');        
        
        list<String> Color = new list<string>();
        Color.add('Red');
        Color.add('Green');
        Color.add('Yellow');
        
        list<list<string>> chk = new list<list<string>>();
        chk.add(fruit);
        chk.add(Color);
        
        system.debug('size: ' + chk.size());
        //system.debug(chk.get(0));
        system.debug('element: ' + chk.get(0).get(1) + 'chk: ' + chk.get(1));
        
     /*
        map<string, list<string>> lst = new map<string, list<string>>();
        lst.put('Fruit', fruit);
        lst.put('Color', Color);
        
        system.debug('size: ' + lst.size());
        system.debug('element: ' + lst.get('Fruit').get(0));
	*/
        
      }
}