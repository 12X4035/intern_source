<?php
/**
 * Created by PhpStorm.
 * User: MyPC
 * Date: 2018/04/27
 * Time: 15:49
 */

namespace app\controllers;

use app\models\LoginForm;
use Yii;
use yii\web\Controller;
use yii\filters\VerbFilter;
use yii\filters\AccessControl;
use app\models\RegisterForm;
use app\models\Users;

class UserController extends Controller
{

    /**
     * {@inheritdoc}
     */
    public function actions()
    {
        return [
            'error' => [
                'class' => 'yii\web\ErrorAction',
            ],
            'captcha' => [
                'class' => 'yii\captcha\CaptchaAction',
                'fixedVerifyCode' => YII_ENV_TEST ? 'testme' : null,
            ],
        ];
    }

    public function actionLogin()
    {
        if (!Yii::$app->user->isGuest) {
            return $this->redirect(['post/index']);
        }

        $model = new LoginForm();
        if ($model->load(Yii::$app->request->post()) && $model->login()) {
            return $this->redirect(['post/index']);
        } else {
            $model->password = '';
            return $this->render('login', [
                'model' => $model,
            ]);
        }
    }

    public function actionLogout()
    {
        Yii::$app->user->logout();
        return $this->redirect(['user/login']);
    }

    /**
     * Displays homepage.
     *
     * @return mixed
     */
    public function actionRegister()
    {
        $model = new RegisterForm();
        if ($model->load(Yii::$app->request->post())) {
            if ($user = $model->register()) {
                if (Yii::$app->getUser()->login($user)) {
                    return $this->redirect(['post/index']);
                }
            }
        }
        return $this->render('register', [
            'model' => $model,
        ]);
    }

    public function actionSetting() {
        if (Yii::$app->user->isGuest) {
            return $this->redirect(['user/login']);
        }
        $user_id = Yii::$app->user->identity->user_id;
        $model = Users::findIdentity($user_id);
        if (!isset($model)) {
            throw new \Exception("This user(user_id: {$user_id}) is not proper.");
        }

        $addressFlg = ($model->personaladdress) ? true : false;

        if ($model->load(Yii::$app->request->post())) {

            // save address and give 100 token
            if (!$addressFlg && $model->personaladdress) {
                $nodeJsPath = Yii::getAlias('@webroot') . '/../scripts/send_token.js';
                $ret = exec("cd ". dirname($nodeJsPath). " && node send_token.js ". $model->personaladdress ." 2>&1", $out, $err);
                if ($err != 0 || (count($out) == 2 && !preg_match("/^0x[0-9a-f]{64}$/", $out[1]))) {
                    Yii::$app->session->setFlash('userFormSubmittedError');
                    return $this->refresh();
                }
            }

            if ($model->save()) {
                Yii::$app->session->setFlash('userFormSubmitted');
                return $this->refresh();
            }
        }
        return $this->render('setting', [
            'model' => $model,
        ]);
    }
 public function actionSettingpool() {
        if (Yii::$app->user->isGuest) {
            return $this->redirect(['user/login']);
        }
        $user_id = Yii::$app->user->identity->user_id;
        $model = Users::findIdentity($user_id);
        if (!isset($model)) {
            throw new \Exception("This user(user_id: {$user_id}) is not proper.");
        }

        $addressFlg = ($model->pooladdress) ? true : false;

        if ($model->load(Yii::$app->request->post())) {

            // save address and give 100 token
            if (!$addressFlg && $model->pooladdress) {
                $nodeJsPath = Yii::getAlias('@webroot') . '/../scripts/send_token.js';
                $ret = exec("cd ". dirname($nodeJsPath). " && node send_token.js ". $model->pooladdress ." 2>&1", $out, $err);
                if ($err != 0 || (count($out) == 2 && !preg_match("/^0x[0-9a-f]{64}$/", $out[1]))) {
                    Yii::$app->session->setFlash('userFormSubmittedError');
                    return $this->refresh();
                }
            }

            if ($model->save()) {
                Yii::$app->session->setFlash('userFormSubmitted');
                return $this->refresh();
            }
        }
        return $this->render('settingpool', [
            'model' => $model,
        ]);
    }

}
