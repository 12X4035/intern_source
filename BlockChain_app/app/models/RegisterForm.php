<?php
/**
 * Created by PhpStorm.
 * User: MyPC
 * Date: 2018/04/27
 * Time: 10:11
 */

namespace app\models;

use yii\base\Model;

/**
 * Register form
 */
class RegisterForm extends Model
{
    public $mail_address;
    public $nickname;
    public $password;
    public $confirm_password;

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            ['mail_address', 'trim'],
            ['mail_address', 'required'],
            ['mail_address', 'email'],
            ['mail_address', 'string', 'max' => 255],
            ['mail_address', 'unique', 'targetClass' => 'app\models\Users', 'message' => 'This email address has already been taken.'],
            [['password', 'confirm_password'], 'required'],
            ['password', 'string', 'min' => 6],
            ['password', 'string', 'max' => 64],
            ['password', 'compare', 'compareAttribute' => 'confirm_password', 'operator' => '=='],
        ];
    }
    /**
     * Signs user up.
     *
     * @return User|null the saved model or null if saving fails
     */
    public function register()
    {
        if (!$this->validate()) {
            return null;
        }
        $user = new Users();
        $user->nickname = $this->nickname;
        $user->mail_address = $this->mail_address;
        $user->setPassword($this->password);

        return $user->save() ? $user : null;
    }
}
