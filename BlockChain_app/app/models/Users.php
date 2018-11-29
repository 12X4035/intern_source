<?php
/**
 * Created by PhpStorm.
 * User: MyPC
 * Date: 2018/04/27
 * Time: 7:56
 */

namespace app\models;

use Yii;

use yii\db\ActiveRecord;
use yii\db\Expression;
use yii\web\IdentityInterface;


/**
 * Users model
 *
 * @property integer $user_id
 * @property string $mail_address
 * @property string $nickname
 * @property string $password
 * @property string $created_at
 * @property string $updated_at
 */

class Users extends ActiveRecord implements IdentityInterface
{


    public static function tableName()
    {
        return 'users';
    }


    public function rules()
    {
        return [
            ['personaladdress', 'trim'],
            ['personaladdress', 'string', 'min' => 40],
            ['personaladdress', 'string', 'max' => 40],
            ['personaladdress', 'match', 'pattern' => '/^(0x)?[0-9a-f]{40}$/i'],
            ['nickname', 'string', 'min' => 3],
            ['nickname', 'string', 'max' => 40],
            [[ 'mail_address', 'password', 'created_at', 'updated_at'], 'safe'],
            ['pooladdress', 'trim'],
            ['pooladdress', 'string', 'min' => 40],
            ['pooladdress', 'string', 'max' => 40],
            ['pooladdress', 'match', 'pattern' => '/^(0x)?[0-9a-f]{40}$/i']
        ];
    }


    /**
     * {@inheritdoc}
     */
    public static function findIdentity($user_id)
    {
        return static::findOne(['user_id' => $user_id]);
    }
    /**
     * {@inheritdoc}
     */
    public static function findIdentityByAccessToken($token, $type = null)
    {
    }


    /**
     * Finds user by nickname
     *
     * @param string $nickname
     * @return static|null
     */
    public static function findByNickname($nickname)
    {
        return static::findOne(['nickname' => $nickname]);
    }



    public static function findByMailAddress($mail_address)
    {
        return static::findOne(['mail_address' => $mail_address]);
    }

    /**
     * {@inheritdoc}
     */
    public function getId()
    {
        return $this->getPrimaryKey();
    }
    /**
     * {@inheritdoc}
     */
    public function getAuthKey(){}
    /**
     * {@inheritdoc}
     */
    public function validateAuthKey($authKey)
    {}


    /**
     * Validates password
     *
     * @param string $password password to validate
     * @return bool if password provided is valid for current user
     */
    public function validatePassword($password)
    {
        return Yii::$app->security->validatePassword($password, $this->password);
    }
    /**
     * Generates password hash from password and sets it to the model
     *
     * @param string $password
     */
    public function setPassword($password)
    {
        $this->password = Yii::$app->security->generatePasswordHash($password);
    }
    public function beforeSave($insert)
    {
        $current_date = 'now()';
        if ($insert) {
            $this->setAttribute('created_at', new Expression($current_date));
        }
        if ($this->hasAttribute('updated_at') && !empty($this->dirtyAttributes)) {
            $this->setAttribute('updated_at', new Expression($current_date));
        }
        return parent::beforeSave($insert);
    }

}
