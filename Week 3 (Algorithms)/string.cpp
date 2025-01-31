#include <iostream>
#include <string>
#include <cctype>
using namespace std;

bool is_word_okay(const string &word){

    int len = word.length();

    if(len > 7 || len < 3){
        return false;
    }

    if(len >= 3 && tolower(word[len - 1]) == 'c' 
    && tolower(word[len - 2]) == 'b' 
    && tolower(word[len - 3]) == 'a'){

        for(int i = 1; i < len; ++i){
            if(tolower(word[i]) == tolower(word[i - 1])){
                return true;
            }
        }
    }
    return false;
}

int main(){

    string s;
    getline(cin, s);

    string word;

    int count = 0;

    for(char c : s){
        if(isalpha(c)){
            word += c;
        } else{
            if(!word.empty() && is_word_okay(word)){
                count++;
            }
            word.clear();
        }
    }

    if(!word.empty() && is_word_okay(word)){
        count++;
    }

    cout << "A215" << " " << count;

    return 0;
}