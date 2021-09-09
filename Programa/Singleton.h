#ifndef SINGLETON_H
#define SINGLETON_H

template <typename T>
class Singleton
{
public:
    static T* getInstance()
    {
        if(! _instance)
            _instance = new T();
        return _instance;
    }
    ~Singleton()
    {
        delete _instance;
    }
private:
    static T*  _instance;
};
template<typename T>
T * Singleton<T>::_instance;

#endif // SINGLETON_H
